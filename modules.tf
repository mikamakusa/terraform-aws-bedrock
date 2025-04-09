module "s3" {
  source                                      = "./modules/terraform-aws-s3"
  bucket                                      = var.s3_bucket
  bucket_versioning                           = var.s3_bucket_versioning
  bucket_server_side_encryption_configuration = var.s3_bucket_server_side_encryption_configuration
  bucket_policy = []
}

module "vpc" {
  source         = "./modules/terraform-aws-vpc"
  vpc            = var.vpc
  vpc_endpoint   = var.vpc_endpoint
  subnet         = var.subnet
  eip            = var.eip
  security_group = var.security_group
  route_table    = var.route_table
}

module "kms" {
  source = "./modules/terraform-aws-kms"
  key    = var.kms_key
}