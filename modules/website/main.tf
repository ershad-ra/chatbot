resource "null_resource" "deploy_site" {
  provisioner "local-exec" {
    command = "aws s3 sync ${var.source_dir} s3://${var.bucket_name} --delete"
  }
}