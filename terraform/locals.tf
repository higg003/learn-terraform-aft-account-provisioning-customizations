locals {

  lambda_contracts_function_name = "aft-add-alternative-contracts"
  lambda_aliases_function_name   = "aft-add-account-alias"
  aft_layer_name                 = "aft-common"
  aft_layer_suffix               = "1-9-0"
  aft_private_subnet_names       = ["aft-vpc-private-subnet-01", "aft-vpc-private-subnet-02"]
  aft_default_sg_name            = "aft-default-sg"
  aft_kms_key_alias              = "alias/aft"
  aft_sns_topic_name             = "aft-notifications"
  aft_failure_sns_topic_name     = "aft-failure-notifications"
  lambda_managed_policies        = [data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn, data.aws_iam_policy.AWSLambdaVPCAccessExecutionRole.arn]
}