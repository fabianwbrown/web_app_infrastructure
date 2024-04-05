resource "aws_s3_bucket" "s3WA" {
  bucket = var.s3_bucket

}

resource "aws_s3_bucket_versioning" "versioning_s3_wa" {
  bucket = aws_s3_bucket.s3WA.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucketowner_wa" {
  bucket = aws_s3_bucket.s3WA.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "aclbucket" {
  depends_on = [aws_s3_bucket_ownership_controls.bucketowner_wa]

  bucket = aws_s3_bucket.s3WA.id
  acl    = "private"
}

resource "aws_dynamodb_table" "DBWA" {
  name         = var.dynamodb_webapp
  hash_key     = "userID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "userID"
    type = "N"
  }

  attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "password"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }
  global_secondary_index {
    name             = "username"
    hash_key         = "username"
    projection_type    = "ALL"
   
  }
  global_secondary_index {
    name             = "password"
    hash_key         = "password"
    projection_type    = "ALL"
   
  }
  global_secondary_index {
    name             = "email"
    hash_key         = "email"
    projection_type    = "ALL"
   
  }
}

resource "aws_dynamodb_table_item" "upload" {
  table_name = aws_dynamodb_table.DBWA.name
  hash_key   = aws_dynamodb_table.DBWA.hash_key

item = <<ITEM
   {

 "userID": {"N":"8383"},

 "username": {"S": "Fbrown"},

 "password": {"S": "successful"},

 "email": {"S": "conclavemanospherecom"}
  
}
ITEM
}

resource "aws_iam_role" "wa_role" {
  name = var.iam_role_webapp

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "RWpolicywebapp" {
  name        = "s3dbRWpolicywebapp"
  path        = "/"
  description = "s3 read write policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "dynamodb:PutItem",
                "dynamodb:GetItem"
            ],
            "Resource": [
                "arn:aws:s3:::bucketwebapp4424,bucketstate4424/*",
                "arn:aws:dynamodb:us-east-1:371448754792:table/dyanmodb_statelock,dynamodb_webapp"
            ]
        }
    ]
}  
EOF
}

resource "aws_iam_role_policy_attachment" "ROpolicyattach" {
  role       = aws_iam_role.wa_role.name
  policy_arn = aws_iam_policy.RWpolicywebapp.arn
}

resource "aws_s3_bucket" "terraform_state_s3" {
  bucket = var.s3_bucket_state

}

resource "aws_s3_bucket_versioning" "versioning_s3_st" {
  bucket = aws_s3_bucket.terraform_state_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucketowner_st" {
  bucket = aws_s3_bucket.terraform_state_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "aclbucket_wa" {
  depends_on = [aws_s3_bucket_ownership_controls.bucketowner_st]

  bucket = aws_s3_bucket.terraform_state_s3.id
  acl    = "private"
}

resource "aws_kms_key" "key_state" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}



resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrytption_state" {
  bucket = aws_s3_bucket.terraform_state_s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key_state.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_table" {
  name         = var.dynamodb_State
  hash_key     = "lock_state"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "lock_state"
    type = "S"
  }
}  

output "wa_role_arn" {
  value = aws_iam_role.wa_role.arn
}

output "s3WA_name" {
  value = aws_s3_bucket.s3WA.bucket
}

output "dynamodb_webapp_name" {
  value = aws_dynamodb_table.DBWA.name
}

output "terraform_state_s3" {
  value = aws_s3_bucket.terraform_state_s3.bucket
}

output "terraform_state_table" {
  value = aws_dynamodb_table.terraform_state_table.name
}