resource "aws_s3_bucket" "Demo_bucket" {
  count         = "${length(var.bucket_name)}"
  bucket        = "${var.bucket_name[count.index]}"
  acl           = "private"
  force_destroy = "true"
  versioning {
    enabled = true
  }
}
