module "msk_cluster" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "~> 2.0"

  name                   = var.project_name
  kafka_version          = "3.4.0"
  number_of_broker_nodes = 3

  broker_node_client_subnets = var.private_subnet_ids
  broker_node_storage_info = {
    ebs_storage_info = { volume_size = 20 }
  }
  broker_node_instance_type   = "kafka.t3.small"
  broker_node_security_groups = []

  encryption_in_transit_client_broker = "TLS"
  encryption_in_transit_in_cluster    = true

  configuration_name        = "${var.project_name}-configuration"
  configuration_description = "Complete ${var.project_name} configuration"
  configuration_server_properties = {
    "auto.create.topics.enable" = true
    "delete.topic.enable"       = true
  }

  client_authentication = {
    sasl = { scram = true }
  }
  create_scram_secret_association          = true
  scram_secret_association_secret_arn_list = [module.secrets_manager_msk.secret_arn]

  # cloudwatch_logs_enabled = true
  # cloudwatch_log_group_name = "${var.project_name}-msk"
  # cloudwatch_log_group_retention_in_days = 1

  tags = var.tags
}

module "secrets_manager_msk" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.0"

  name_prefix = "AmazonMSK_${var.project_name}-"
  description = "Secret for ${var.project_name}"

  # Secret
  recovery_window_in_days = 0
  secret_string           = jsonencode({ username = var.kafka_username, password = var.kafka_password })
  kms_key_id              = aws_kms_key.this.id

  # Policy
  create_policy       = true
  block_public_policy = true
  policy_statements = {
    read = {
      sid = "AWSKafkaResourcePolicy"
      principals = [{
        type        = "Service"
        identifiers = ["kafka.amazonaws.com"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  tags = var.tags
}

resource "aws_kms_key" "this" {
  description         = "KMS CMK for ${var.project_name}"
  enable_key_rotation = true

  tags = var.tags
}