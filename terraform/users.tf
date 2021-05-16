resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "user_pki_all" {
  path = "auth/userpass/users/pki_all"

  depends_on = [
    vault_auth_backend.userpass
  ]

  data_json = <<EOT
{
  "password": "superSecretPassword",
  "policies": "admin,pki-issue-all"
}
EOT
}

# TODO: User with access to fewer roles
