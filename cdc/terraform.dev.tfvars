Aqui estão os arquivos `terraform.dev.tfvars` preenchidos com valores fictícios:

```terraform-vars
project_name = "poc-dms-oracle-kafka"
tags = {
    domain = "data-integration",
    application = "dms-cdc",
    tag_created = "2023-10-27",
    board = "data-platform",
    company = "example-company",
    env = "dev",
    shared = "false"
}

# Kafka DMS Target Endpoint settings
kafka_bootstrap_brokers = "kafka-dev-01.example.com:9092,kafka-dev-02.example.com:9092,kafka-dev-03.example.com:9092"
kafka_username="kafka-user-dev"
kafka_password="kafka-password-dev"
kafka_topic_prefix = "dms-cdc-dev"

# Oracle DMS Source Endpoint settings
db_name="ORCLDEV"
db_endpoint="oracle-dev.example.com"
db_username="dms_user"
db_password="dms_user_password"
db_port=1524

# Tables to replicate from Oracle to Kafka
replicated_tables = [
    { 
        schema = "SCHEMA_A", 
        tables = ["TABLE_1", "TABLE_2"]
    },
    { 
        schema = "SCHEMA_B", 
        tables = ["TABLE_3"]
    }
]

# DMS Instance Settings
vpc_id = "vpc-0abcdef1234567890"
dms_instance_class =  "dms.t3.small"
