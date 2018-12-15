variable "allowed_roles" {
  description = "list of roles to allow through vault"
  default     = []
  type        = "list"
}

variable "mount_path" {
  description = "path to mount the database secret backend in Vault"
  default     = "postgres"
  type        = "string"
}

variable "password" {
  description = "password to connect to postgres with"
  default     = "postgres"
  type        = "string"
}

variable "username" {
  description = "username to connect to postgres with"
  default     = "postgres"
  type        = "string"
}

variable "database" {                                                                  
  description = "name of database to connect to"
  default     = "postgres"
  type        = "string"
} 

variable "host" {                                                                     
  description = "hostname/IP to postgres"                                             
  default     = "localhost"
  type        = "string"                                                              
} 

variable "port" {
  description = "port where postgres runs"
  default     = "5432"
  type        = "string"
}

variable "ssl_mode" {
  description = "require (default), verify-full, verify-ca, and disable supported, controls if TLS is used to connect to postgres"
  default     = "disable"
  type        = "string"
}

# https://www.terraform.io/docs/providers/vault/r/mount.html
resource "vault_mount" "postgres" {
  path = "${var.mount_path}"
  type = "database"
}

# https://www.terraform.io/docs/providers/vault/r/database_secret_backend_connection.html
resource "vault_database_secret_backend_connection" "postgres" {
  backend = "${vault_mount.postgres.path}"
  name    = "postgres"
  allowed_roles = ["${var.allowed_roles}"]

  postgresql {
    connection_url = "postgres://${var.username}:${var.password}@${var.host}:${var.port}/${var.database}?sslmode=${var.ssl_mode}"
  }
}

# https://www.terraform.io/docs/providers/vault/r/database_secret_backend_role.html
resource "vault_database_secret_backend_role" "ops" {
  backend = "${vault_mount.postgres.path}"
  name    = "ops"
  db_name = "${vault_database_secret_backend_connection.postgres.name}"

  creation_statements = "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"
}
