# PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# BUCKET S3
resource "aws_s3_bucket" "s3-guilherme-fiap" {
  bucket = "s3-guilherme-fiap"
}

# POLICY S3
resource "aws_s3_bucket_policy" "policys3" {
  bucket = aws_s3_bucket.s3-guilherme-fiap.id

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::s3-guilherme-fiap/*",
      }
    ]
	})
}

# VERSIONING S3 BUCKET
resource "aws_s3_bucket_versioning" "versionings3" {
  bucket = aws_s3_bucket.s3-guilherme-fiap.id
  versioning_configuration {
    status = "Enabled"
  }
}

# STATIC SITE
resource "aws_s3_bucket_website_configuration" "sites3" {
  bucket = aws_s3_bucket.s3-guilherme-fiap.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 BUCKET OBJECTS
resource "aws_s3_bucket_object" "s3-guilherme-fiap-objects" {
    bucket   = aws_s3_bucket.s3-guilherme-fiap.id
    for_each = fileset("data/", "*")
    key      = each.value
    source   = "data/${each.value}"
    acl      = "public-read"
}
