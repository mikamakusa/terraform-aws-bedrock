resource "aws_s3_bucket" "this" {
  count               = length(var.s3_bucket)
  bucket              = lookup(var.s3_bucket[count.index], "bucket")
  bucket_prefix       = lookup(var.s3_bucket[count.index], "bucket_prefix")
  force_destroy       = lookup(var.s3_bucket[count.index], "force_destroy")
  object_lock_enabled = lookup(var.s3_bucket[count.index], "object_lock_enabled")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.s3_bucket[count.index], "tags")
  )
}

resource "aws_s3_bucket_versioning" "this" {
  count = length(var.s3_bucket) == 0 ? 0 : length(var.s3_bucket_versioning)
  bucket = try(
    element(aws_s3_bucket.this.*.id, lookup(var.s3_bucket_versioning[count.index], "bucket_id"))
  )
  expected_bucket_owner = lookup(var.s3_bucket_versioning[count.index], "expected_bucket_owner")
  mfa                   = lookup(var.s3_bucket_versioning[count.index], "mfa")

  dynamic "versioning_configuration" {
    for_each = lookup(var.s3_bucket_versioning[count.index], "versioning_configuration") == null ? [] : ["versioning_configuration"]
    content {
      status     = lookup(versioning_configuration.value, "status")
      mfa_delete = lookup(versioning_configuration.value, "mfa_delete")
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = length(var.s3_bucket) == 0 ? 0 : length(var.s3_bucket_server_side_encryption_configuration)
  bucket = try(
    element(aws_s3_bucket.this.*.id, lookup(var.s3_bucket_server_side_encryption_configuration[count.index], "bucket_id"))
  )
  expected_bucket_owner = lookup(var.s3_bucket_server_side_encryption_configuration[count.index], "expected_bucket_owner")

  dynamic "rule" {
    for_each = lookup(var.s3_bucket_server_side_encryption_configuration[count.index], "rule") == null ? [] : ["rule"]
    content {
      bucket_key_enabled = lookup(rule.value, "bucket_key_enabled")

      dynamic "apply_server_side_encryption_by_default" {
        for_each = lookup(rule.value, "apply_server_side_encryption_by_default") == null ? [] : ["apply_server_side_encryption_by_default"]
        content {
          sse_algorithm     = lookup(apply_server_side_encryption_by_default.value, "sse_algorithm")
          kms_master_key_id = var.s3_encryption_kms_master_key_id
        }
      }
    }
  }
}