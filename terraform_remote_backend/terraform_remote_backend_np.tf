resource "aws_s3_bucket" "terraform_state_np" {
  bucket = "${var.PROJECT_NAME}-np-terraform-state"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_np" {
  bucket = aws_s3_bucket.terraform_state_np.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_np" {
  bucket = aws_s3_bucket.terraform_state_np.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_np" {
  bucket                  = aws_s3_bucket.terraform_state_np.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_np" {
  name         = "${var.PROJECT_NAME}-np-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
