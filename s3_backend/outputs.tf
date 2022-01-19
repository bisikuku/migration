output "bucket_region" {
  value = module.s3-state.bucket_region
}

output "bucket_name" {
  value = module.s3-state.bucket_name
}

output "bucket_arn" {
  value = module.s3-state.bucket_arn
}

output "dynamodb_table_name" {
  value = module.s3-state.dynamodb_table_name
}

output "dynamodb_table_arn" {
  value = module.s3-state.dynamodb_table_arn
}

