# Create S3 bucket
resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "my-tf-test-bucket"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "Enabled" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "my-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "my-lock-table"
    Environment = "Dev"
  }
}



#terraform {
 # backend "s3" {
 #   bucket         = "my-state-bucket"  # Replace with your S3 bucket name
 #   key            = "dev/terraform.tfstate"  # Replace with your desired key (path to the state file in the bucket)
 #   region         = "us-east-1"                  # Replace with your AWS region
#  dynamodb_table = "my-lock-table"    # Replace with your DynamoDB table name
 #   encrypt        = true
 # }
#}
