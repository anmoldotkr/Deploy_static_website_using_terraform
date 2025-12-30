output "s3_bucket" {
  value = aws_s3_bucket.this.id
}
output "s3_bucket_arn" {
  value = aws_s3_bucket.this.arn
}
output "s3_bucket_website_endpoint" {
  value = aws_s3_bucket.this.bucket_domain_name
}
output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}