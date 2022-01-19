###########################
# S3 Remote state module
###########################

# Provides a KMS customer master key.
resource "aws_kms_key" "encryption_key" {
  description             = "KMS key used to encrypt objects in the S3 Bucket"
  deletion_window_in_days = var.deletion_window_in_days_kms_key
  enable_key_rotation     = var.enable_key_rotation

  tags = merge(
    {
      "Name" = format("%s", "${var.env_class}-${var.backend_s3_bucket}")
    },
    var.common_tags,
  )
}

# Provides an alias for a KMS customer master key
resource "aws_kms_alias" "encryption_key" {
  target_key_id = aws_kms_key.encryption_key.key_id
  name          = "alias/${var.env_class}-${var.backend_s3_bucket}"
}

# S3 Bucket to hold state.
resource "aws_s3_bucket" "s3_backend" {
  count  = var.create_s3_bucket ? 1 : 0
  acl    = "private"
  bucket = "tdoc2-${var.env_class}-${var.backend_s3_bucket}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.encryption_key.key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = var.versioning
  }

  lifecycle {
    prevent_destroy = true # Set to true, false only for developing and test purposes.
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = format("%s", "tdoc-${var.env_class}-${var.backend_s3_bucket}")
    }
  )
}

# Policy to prevent unencrypted data at transport
resource "aws_s3_bucket_policy" "s3_tf_remote_state_bucket_require_transport_encription" {
  count  = var.prevent_unencrypted_on ? 1 : 0
  bucket = aws_s3_bucket.s3_backend[0].id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "RequireEncryption",
   "Statement": [
    {
      "Sid": "RequireEncryptedTransport",
      "Effect": "Deny",
      "Action": ["s3:*"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.s3_backend[0].bucket}/*"],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": "*"
    }
  ]
}
EOF

}

# DynamoDB table to lock state during applies
resource "aws_dynamodb_table" "terraform_state_lock" {
  count          = var.create_dynamodb_lock_table ? 1 : 0
  name           = "${var.env_class}_${var.backend_dynamodb_lock_table}"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    {
      "Name" = format("%s", "${var.env_class}_${var.backend_dynamodb_lock_table}")
    },
    var.common_tags,
  )
}

/* Local file for next init to move state to s3.
   After initial apply, run 
    terraform init -force-copy
   to auto-copy state up to s3
*/
resource "local_file" "terraform_tf" {
  content = <<EOF
        bucket         = "tdoc-${var.env_class}-${var.backend_s3_bucket}"
        acl            = "${var.acl}"
        key            = "${var.key_name}"
        region         = "us-west-2"
        encrypt        = "${var.use_bucket_encryption}"
        dynamodb_table = "${var.env_class}_${var.backend_dynamodb_lock_table}"
    
EOF


  filename = "${path.root}/backend.txt"
}

