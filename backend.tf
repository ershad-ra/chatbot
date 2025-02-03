terraform {
  backend "s3" {
    bucket         = "ershad-remi-tf-state-do-not-delete"           # S3 bucket name
    key            = "state/terraform.tfstate"                      # Path to store the state file in the bucket
    region         = "eu-west-1"                                    # AWS region where the bucket is located
    encrypt        = true                                           # Enable server-side encryption for the state file
  }
}