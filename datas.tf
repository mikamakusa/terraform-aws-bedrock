data "aws_bedrock_foundation_model" "this" {
    model_id = var.bedrock_foundation_model_id
}

data "aws_default_tags" "this" {}

data "aws_vpc" "this" {
    count = var.vpc_id ? 1 : 0
    id    = var.vpc_id
}

data "aws_eip" "this" {
    count = var.eip_id ? 1 : 0
    id    = var.eip_id
}

data "aws_subnet" "this" {
    count = var.subnet_id ? 1 : 0
    id    = var.subnet_id
}

data "aws_vpc_endpoint" "this" {
    count = var.vpc_endpoint_id ? 1 : 0
    id    = var.vpc_endpoint_id
}