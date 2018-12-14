# This will let a bearer have full access to the secrets path in Vault
resource "vault_policy" "vault-secrets" {
  name   = "vault-secrets-full-access"
  policy = "${file("${path.module}/policy.hcl")}"
}


