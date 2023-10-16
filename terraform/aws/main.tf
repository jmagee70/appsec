terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}



provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "web_host" {
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    yor_trace = "4b2c131e-93bf-4fa4-a72a-e39b8e7e6ff3"
  }
}



resource "aws_ebs_volume" "ebs-web-storage" {
  availability_zone = "${var.region}a"
  size              = 40
  tags = {
    yor_trace = "69e40cd6-8c54-4dc3-b843-c602ba352f01"
  }
}


resource "aws_s3_bucket" "test_bucket" {
  bucket        = "my-test-bucket"
  force_destroy = true
  acl           = "public-read"
  tags = {
    yor_trace = "3d5bfcbd-5db0-47cc-8954-43d1c47c5be3"
  }
}