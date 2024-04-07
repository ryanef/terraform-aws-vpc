data "aws_availability_zones" "available" {
  state         = "available"
  exclude_names = var.az_exclude_names
}

data "aws_iam_policy_document" "flowpolicy" {
statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:GetLogDelivery",
      "firehose:TagDeliveryStream",
    ]

    resources = ["*"]
  }
}