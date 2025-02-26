Aqui estão os arquivos `terraform.stg.tfvars` preenchidos com valores fictícios:

```terraform-vars
project_name = "poc-dms-oracle-kafka"
tags = {
    domain = "data-integration",
    application = "dms-cdc",
    tag_created = "2023-10-27",
    board = "data-platform",
    company = "example-company",
    env = "stg",
    shared = "false"
}

# Kafka DMS Target Endpoint settings
kafka_bootstrap_brokers = "kafka-stg-01.example.com:9092,kafka-stg-02.example.com:9092,kafka-stg-03.example.com:9092"
kafka_username="kafka-user-stg"
kafka_password="kafka-password-stg"
kafka_topic_prefix = "dms-cdc-stg"

# Oracle DMS Source Endpoint settings
db_name="ORCLstg"
db_endpoint="oracle-stg.example.com"
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