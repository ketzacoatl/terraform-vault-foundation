# A basic policy for secrets

# Using this policy grants broad access to all secrets
# This is temporary - for now this is a placeholder policy to demonstrate how to connect to Vault with Terraform.
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
