output "dev_ip" {
  value = aws_instance.dev_node.public_ip
}

output "s3_arn" {
  value = aws_s3_bucket.my_bucket.arn
}