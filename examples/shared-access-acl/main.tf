module "bucket" {
  source = "../.."

  name = "my-shared-bucket"

  # ID of the project owning the bucket, required by Scaleway when granting access.
  acl_owner_id = "11111111-1111-1111-1111-111111111111"

  acl_grants = [
    {
      grantee_id   = "22222222-2222-2222-2222-222222222222"
      grantee_type = "CanonicalUser"
      permission   = "READ"
    },
    {
      grantee_uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
      grantee_type = "Group"
      permission   = "READ"
    }
  ]
}
