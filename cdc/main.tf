provider "aws" {
    region = "us-east-1"
    profile = "DataOps_${terraform.workspace}"
}


data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
    azs  = slice(data.aws_availability_zones.available.names, 0, 3)
    account_id = data.aws_caller_identity.current.account_id
    dns_suffix = data.aws_partition.current.dns_suffix
    partition  = data.aws_partition.current.partition
    region     = data.aws_region.current.name
    replicated_tables = flatten([
    for item in var.replicated_tables : [
      for table_name in item.tables : {
        schema = item.schema,
        table  = table_name
      }
    ]
  ])
}

data "aws_vpc" "current_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.current_vpc.id]
  }

  tags = {
    Network = "Private"
  }
}