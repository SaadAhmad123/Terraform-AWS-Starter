output "secret" {
  value = aws_secretsmanager_secret.this
}

output "read_policy" {
  value = aws_iam_policy.this
}
