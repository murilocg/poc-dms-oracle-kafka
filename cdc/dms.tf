resource "aws_cloudwatch_log_group" "dms_serverless_replication" {
  name              = "dms-serverless-replication-oracle-kafka"
  retention_in_days = 7
  tags              = var.tags
}

resource "aws_security_group" "dms_security_group" {
  name_prefix = "${var.project_name}-dms-sg"
  vpc_id      = data.aws_vpc.current_vpc.id
  tags        = var.tags

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add any additional ports needed for Confluent Kafka here
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "dms_oracle_kafka" {
  source = "terraform-aws-modules/dms/aws"
  version = "~> 2.0"

  repl_subnet_group_name        = var.project_name
  repl_subnet_group_description = "DMS Subnet group for ${var.project_name}"
  repl_instance_allocated_storage            = 64
  repl_instance_auto_minor_version_upgrade   = var.dms_auto_minor_version_upgrade
  repl_instance_allow_major_version_upgrade  = var.dms_allow_major_version_upgrade
  repl_instance_apply_immediately            = true
  repl_instance_engine_version               = var.dms_engine_version
  repl_instance_multi_az                     = var.dms_multi_az
  repl_instance_preferred_maintenance_window = var.dms_preferred_maintenance_window
  repl_instance_publicly_accessible          = false
  repl_instance_class                        = var.dms_instance_class
  repl_instance_id                           = var.project_name
  repl_instance_vpc_security_group_ids       = [aws_security_group.dms_security_group.id]
  repl_subnet_group_subnet_ids               = data.aws_subnets.private.ids
  create_repl_instance                       = true

  create_iam_roles            = true
  create_access_iam_role      = true
  access_iam_role_name        = "${var.project_name}-iam-role"
  access_iam_role_use_name_prefix = true

  endpoints = merge({ for k, v in local.replicated_tables : "kfk-${replace(lower(v["table"]),"_", "-")}" => {
        endpoint_id = "kfk-${replace(lower(v["table"]),"_", "-")}",
        endpoint_type = "target",
        engine_name="kafka",
        kafka_settings = {
          broker                  = var.kafka_bootstrap_brokers
          include_control_details = true
          include_null_and_empty  = true
          message_format          = "json"
          sasl_username           = var.kafka_username
          sasl_password           = var.kafka_password
          security_protocol       = "sasl-ssl"
          sasl_mechanism          = "PLAIN"
          topic                   = "${var.kafka_topic_prefix}_${v["table"]}"
        }
      }
    },
    {
      oracle_source = {
        database_name = var.db_name,
        endpoint_id   = "${var.project_name}-oracle-source",
        endpoint_type = "source",
        engine_name   = "oracle",
        username      = var.db_username,
        password      = var.db_password,
        server_name   = var.db_endpoint,
        port          = var.db_port,
        tags          = var.tags,
    }
  })

  replication_tasks = {
    for k, v in local.replicated_tables : "orl-kfk-${replace(lower(v["table"]),"_", "-")}" => {
      replication_task_id         = "orl-kfk-${replace(lower(v["table"]),"_", "-")}"
      migration_type              = var.dms_migration_type
      replication_task_settings   = file("config/task_settings.json")
      table_mappings              = templatefile("config/table_mappings.json.tmpl", v)
      source_endpoint_key         = "oracle_source"
      target_endpoint_key         = "kfk-${replace(lower(v["table"]),"_", "-")}"
      tags = var.tags
    }
  }
  tags = var.tags
}
