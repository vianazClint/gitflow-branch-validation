variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
  sensitive = true
}

locals {
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
    region = "us-east-1"
    access_key = local.access_key
    secret_key = local.secret_key
}

resource "aws_s3_bucket" "s3-bucket" {
    force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "s3-bucket" {
  depends_on = [ aws_s3_bucket.s3-bucket ]
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.s3-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.s3-bucket.id
  depends_on = [ aws_s3_bucket.s3-bucket ]
  policy = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    sid = "AllowPublicRead"

    principals {
      type = "*"
      identifiers = [ "*" ]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.s3-bucket.arn}/*",
    ]
  }
}

output "bucket" {
  depends_on = [ aws_s3_bucket.s3-bucket ]
  value = aws_s3_bucket.s3-bucket.bucket
}
output "deploy_url" {
  depends_on = [ aws_s3_bucket.s3-bucket ]
  value = aws_s3_bucket_website_configuration.website.website_domain
}

