resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "pki-issue-all" {
  backend            = vault_auth_backend.approle.path
  role_name          = "pki-issue-all"
  token_policies     = ["pki-issue-all"]
  token_ttl          = 300
  role_id            = "pki-issue-all"
  secret_id_num_uses = 0
}

resource "vault_approle_auth_backend_role_secret_id" "pki-issue-all" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.pki-issue-all.role_name

  # We would not normally want to hard-code a Secret ID here
  # But because we reference it in other parts of the demonstration, it makes
  # things easier
  secret_id = "c9b3d349-c0cd-4763-863b-7babaeda82ad"

  metadata = <<EOT
{
  "terraform": "true",
  "resource": "vault_approle_auth_backend_role_secret_id.pki-issue-all"
}
EOT
}
