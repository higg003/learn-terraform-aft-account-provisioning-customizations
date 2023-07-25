resource "aws_sfn_state_machine" "aft_account_provisioning_customizations" {
  name       = "aft-account-provisioning-customizations"
  role_arn   = aws_iam_role.aft_states.arn
  definition = templatefile("${path.module}/states/customizations.asl.json", {
    aft_add_alternate_contacts_function_arn = aws_lambda_function.aft_add_alternative_contracts.arn
    current_partition                       = data.aws_partition.current.partition
    aft_notification_arn                   = data.aws_sns_topic.aft_notifications.arn
    aft_failure_notification_arn           = data.aws_sns_topic.aft_failure_notifications.arn
  })
}