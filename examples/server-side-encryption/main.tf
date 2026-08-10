# SSE-ONE: Scaleway manages the encryption key, no further configuration required.
module "sse_one_bucket" {
  source = "../.."

  name          = "my-sse-one-bucket"
  sse_algorithm = "AES256"
}

# SSE-KMS: encryption relies on a customer-managed Key Manager key, created
# beforehand (e.g. with a dedicated Key Manager module).
module "sse_kms_bucket" {
  source = "../.."

  name          = "my-sse-kms-bucket"
  sse_algorithm = "aws:kms"

  kms_master_key_id  = "11111111-1111-1111-1111-111111111111"
  bucket_key_enabled = true
}
