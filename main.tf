provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  # address = "https://vault.example.net:8200"

  # set via the VAULT_TOKEN environment variable for now
  # token = "" # TODO eventually add
}

module "vault-secrets-full-access" {
  source = "./vault-secrets-full-access"
}
