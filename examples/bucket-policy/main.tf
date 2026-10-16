module "bucket" {
  source = "../.."

  name = "my-policy-bucket"

  policy = {
    Version = "2023-04-17"
    Id      = "my-policy-bucket-policy"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = ["*"]
        Action    = ["s3:GetObject"]
        Resource  = ["my-policy-bucket/public/*"]
      },
      {
        Sid       = "SingleUserFullAccess"
        Effect    = "Allow"
        Principal = ["user_id:11111111-1111-1111-1111-111111111111"]
        Action    = ["s3:*"]
        Resource  = ["my-policy-bucket", "my-policy-bucket/*"]
      },
      {
        Sid    = "UserAndApplicationReadWrite"
        Effect = "Allow"
        Principal = [
          "user_id:22222222-2222-2222-2222-222222222222",
          "application_id:33333333-3333-3333-3333-333333333333",
        ]
        Action   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
        Resource = ["my-policy-bucket", "my-policy-bucket/*"]
      },
    ]
  }
}
