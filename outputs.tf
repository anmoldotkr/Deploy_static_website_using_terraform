# This file is export the name of the resources

output "s3_bucket" {
  value = module.s3_bucket.s3_bucket
  description = "Bucket Name"
}
output "s3_bucket_arn" {
  description = "Bucket Arn"
  value = module.s3_bucket.s3_bucket_arn
}
output "s3_bucket_website_endpoint" {
  description = "Bucket website endpoint"
  value = module.s3_bucket.s3_bucket_website_endpoint
}

output "s3_bucket_regional_domain_name" {
  value = module.s3_bucket.s3_bucket_regional_domain_name
  description = "Bucket Regional Domain endpoint"
}