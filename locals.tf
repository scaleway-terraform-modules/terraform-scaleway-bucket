locals {
  # Scaleway expects each statement's Principal to be either "*", {"SCW" = "<id>"} or {"SCW" = ["<id>", ...]}.
  # Terraform conditionals and lists require a single type, so each shape is JSON-encoded then decoded back,
  # and statements are built as a tuple so that they can hold different Principal types.
  # Null attributes (e.g. Id or Sid explicitly set to null) are dropped from the rendered document.
  policy = var.policy == null ? null : {
    for key, value in {
      Version = var.policy.Version
      Id      = var.policy.Id
      Statement = [
        for statement in var.policy.Statement : {
          for key, value in merge(statement, {
            Principal = jsondecode(
              contains(statement.Principal, "*") ? jsonencode("*") :
              length(statement.Principal) == 1 ? jsonencode({ SCW = statement.Principal[0] }) :
              jsonencode({ SCW = statement.Principal })
            )
          }) : key => value if value != null
        }
      ]
    } : key => value if value != null
  }
}
