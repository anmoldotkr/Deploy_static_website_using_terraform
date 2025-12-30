# This file contain the code of creation s3 bucket.
locals {
  evironment = "dev"
  product = "dummy09"
  service = "s3"
}
# Creating Private S3 Bucket

resource "aws_s3_bucket" "this" {
  bucket = "${local.evironment}-${local.product}-${local.service}"
  force_destroy = true
  tags = {
    evironment = local.evironment
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}
