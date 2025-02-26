# variable "vpc_cidr" {
#     type = string
#     description = "VPC's CIDR"
# }

variable "vpc_id" {
    type = string
    description = "VPC's ID"
}

variable "project_name" {
    type = string
    description = "Project's name"
}

variable "tags" {
    type = map(any)
    description = "Project's tags"
}

variable "kafka_bootstrap_brokers" {
    description = "Kafka brokers to target endpoint"
    type = string
}

variable "kafka_username" {
    description = "Username for Kafka DMS Target Endpoint"
    type = string
}

variable "kafka_password" {
    description = "Passsword for Kafka DMS Target Endpoint"
    type = string
    sensitive = true
}

variable "kafka_topic_prefix" {
    description = "Kafka topic prefix to concat with the table name"
    type = string
}

variable "db_name"{
    description = "DB name for Oracle DMS Source endpoint"
    type = string
}

variable "db_endpoint"{
    description = "DB host for Oracle DMS Source endpoint"
    type = string
}

variable "db_username" {
    description = "DB's username for Oracle DMS Source Endpoint"
    type = string
}

variable "db_password" {
    description = "DB's password for Oracle DMS Source Endpoint"
    type = string
    sensitive = true
}

variable "db_port" {
    description = "DB's port for Oracle DMS Source Endpoint"
    type = number
}

variable "replicated_tables" {
    description = "List of tables to be replicated"
    type = list(object({
        schema = string
        tables = list(string)
    }))
}

variable "dms_instance_class" {
    description = "Instance class name to the DMS instance"
    type = string
}

variable "dms_multi_az" {
    description = "Deploy multi az?"
    type = bool
    default = false
}

variable "dms_auto_minor_version_upgrade" {
    description = "Update DMS minor versions?"
    type = bool
    default = true
}

variable "dms_allow_major_version_upgrade" {
    description = "Update DMS major versions?"
    type = bool
    default = false
}

variable "dms_engine_version" {
    description = "DMS Instance Engine Version"
    type = string
    default = "3.5.3"
}

variable "dms_preferred_maintenance_window" {
    description = "Deploy multi az?"
    type = string
    default = "sun:10:30-sun:14:30"
}


variable "dms_migration_type" {
    description = "DMS migration type (full-load, cdc, full-load-and-cdc)"
    type = string
    default = "cdc"
}