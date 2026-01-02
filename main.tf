# This file is responsible for creating the s3 and cdn resources in aws.

module "s3WithCdn" {
    source = "./modules/s3WithCdn"
}
