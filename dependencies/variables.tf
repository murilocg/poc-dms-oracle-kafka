variable "vpc_cidr" {
    type = string
    description = "VPC's CIDR"
}

variable "vpc_id" {
    type = string
    description = "VPC's ID"
}

variable "project_name" {
    type = string
    description = "Project name"
}

variable "tags" {
    type = map(any)
    description = "Project's tags"
}

variable "public_subnet_ids"{
    type = list(string)
}

variable "private_subnet_ids"{
    type = list(string)
}


variable "db_name" {
    type = string
}

variable "db_username" {
    type = string
    sensitive = true
}

variable "db_password" {
    type = string
    sensitive = true
}

variable "kafka_username" {
    type = string
    sensitive = true
}

variable "kafka_password" {
    type = string
    sensitive = true
}