###################################################################
# Step Function - Account Provisioning Customizations
###################################################################

resource "aws_iam_role" "aft_states" {
  name               = "aft-account-provisioning-customizations-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/states.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_states" {
  name = "aft-account-provisioning-customizations-policy"
  role = aws_iam_role.aft_states.id

  policy = templatefile("${path.module}/iam/role-policies/iam-aft-states.tpl", {
    data_aws_partition_current_partition               = data.aws_partition.current.partition
    data_aws_region_aft-management_name                = data.aws_region.current.name
    data_aws_caller_identity_aft-management_account_id = data.aws_caller_identity.current.id
  })
}

###################################################################
# Lambda - Add Alternative Contacts
###################################################################

resource "aws_iam_role" "aft_add_alternative_contracts_lambda" {
  name               = "aft-add-alternative-contracts-execution-role"
  assume_role_policy = templatefile("${path.module}/iam/trust-policies/lambda.tpl", { none = "none" })
}

resource "aws_iam_role_policy" "aft_add_alternative_contracts_lambda" {
  name = "aft-add-alternative-contracts-policy"
  role = aws_iam_role.aft_add_alternative_contracts_lambda.id

  policy = templatefile("${path.module}/iam/role-policies/aft_add_alternative_contracts_lambda.tpl", {
    data_aws_caller_identity_current_account_id = data.aws_caller_identity.current.account_id
    data_aws_partition_current_partition        = data.aws_partition.current.partition
    data_aws_region_current_name                = data.aws_region.current.name
    aws_kms_key_aft_arn                         = data.aws_kms_key.aft_key.arn
    aws_sns_topic_aft_notifications_arn         = data.aws_sns_topic.aft_notifications.arn
    aws_sns_topic_aft_failure_notifications_arn = data.aws_sns_topic.aft_failure_notifications.arn
  })

}

resource "aws_iam_role_policy_attachment" "aft_add_alternative_contracts_lambda" {
  count      = length(local.lambda_managed_policies)
  role       = aws_iam_role.aft_add_alternative_contracts_lambda.name
  policy_arn = local.lambda_managed_policies[count.index]
}