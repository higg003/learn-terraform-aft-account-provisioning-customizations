data "aws_subnet" "aft_private_subnets" {
  for_each = toset(local.aft_private_subnet_names)
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
}

data "aws_security_group" "aft_default_sg" {
  name = local.aft_default_sg_name
}

data "aws_lambda_layer_version" "aft_common" {
  layer_name = "${local.aft_layer_name}-${local.aft_layer_suffix}"
}

data "aws_kms_key" "aft_key" {
  key_id = local.aft_kms_key_alias
}

data "aws_sns_topic" "aft_notifications" {
  name = local.aft_sns_topic_name
}

data "aws_sns_topic" "aft_failure_notifications" {
  name = local.aft_failure_sns_topic_name
}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "AWSLambdaVPCAccessExecutionRole" {
  name = "AWSLambdaVPCAccessExecutionRole"
}