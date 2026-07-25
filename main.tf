provider "aws" {
  region = "eu-west-3"
}

# 1. Création du bucket S3
resource "aws_s3_bucket" "projet_bucket" {
  bucket = "mon-super-bucket-devsecops-unique-2026"
}

# 2. Correction CKV2_AWS_6 : Blocage strict des accès publics
resource "aws_s3_bucket_public_access_block" "projet_bucket_block" {
  bucket                  = aws_s3_bucket.projet_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Correction CKV_AWS_21 : Activation du Versioning
resource "aws_s3_bucket_versioning" "projet_bucket_versioning" {
  bucket = aws_s3_bucket.projet_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Correction CKV_AWS_145 / CKV_AWS_19 : Chiffrement côté serveur par défaut (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "projet_bucket_encryption" {
  bucket = aws_s3_bucket.projet_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}