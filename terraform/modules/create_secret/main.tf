resource "aws_secretsmanager_secret" "this" {
  name        = var.name
  description = var.description
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.value
}

data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      aws_secretsmanager_secret.this.arn
    ]
  }
}

resource "aws_iam_policy" "this" {
  name   = "ssm-${replace(var.name, "/[^\\w+=,.@-]/", "-")}-policy"
  policy = data.aws_iam_policy_document.this.json
  tags   = var.tags
}
