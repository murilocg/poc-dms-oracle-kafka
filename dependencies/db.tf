module "oracle" {
    source = "terraform-aws-modules/rds/aws"
    
    identifier = var.project_name
    engine = "oracle-se2"
    engine_version = "19"
    family = "oracle-se2-19"
    major_engine_version = "19"
    instance_class = "db.t3.small"
    license_model = "license-included"

    allocated_storage     = 20
    max_allocated_storage = 100
    publicly_accessible = true


    maintenance_window              = "Mon:00:00-Mon:03:00"
    backup_window                   = "03:00-06:00"
    backup_retention_period         = 2


    db_name  = var.db_name
    username = var.db_username
    password = var.db_password
    port     = 1521

    character_set_name       = "AL32UTF8"
    nchar_character_set_name = "AL16UTF16"


    vpc_security_group_ids  = [module.security_group_oracle.security_group_id]
    create_db_subnet_group = true
    subnet_ids             = var.public_subnet_ids
    tags = var.tags
}


module "security_group_oracle" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.project_name}-oracle-source"
  description = "Security group for oracle source"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["oracle-db-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.tags
}