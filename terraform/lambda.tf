resource "aws_lambda_function" "aft_add_alternative_contracts" {
  filename      = data.archive_file.aft_add_alternative_contracts.output_path
  function_name = "aft-add-alternative-contracts"
  description   = "Adds Alternate Contacts in the newly provisioned account"
  role          = aws_iam_role.aft_add_alternative_contracts_lambda.arn
  handler       = "aft_add_alternative_contracts.lambda_handler"

  source_code_hash = data.archive_file.aft_add_alternative_contracts.output_base64sha256
  memory_size      = 1024
  runtime          = "python3.9"
  timeout          = "300"
  layers           = [data.aws_lambda_layer_version.aft_common.arn]

  vpc_config {
    subnet_ids         = [for subnet in data.aws_subnet.aft_private_subnets : subnet.id]
    security_group_ids = [data.aws_security_group.aft_default_sg.id]
  }
}

resource "aws_cloudwatch_log_group" "aft_add_alternative_contracts" {
  name              = "/aws/lambda/${aws_lambda_function.aft_add_alternative_contracts.function_name}"
  retention_in_days = 60
}

data "archive_file" "aft_add_alternative_contracts" {
  type        = "zip"
  source_dir  = "${path.module}/src/aft_account_provisioning_customisations/aft_add_alternative_contracts"
  output_path = "${path.module}/src/aft_account_provisioning_customisations/aft_add_alternative_contracts.zip"
}