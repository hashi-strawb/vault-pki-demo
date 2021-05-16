resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "pki-issue-all" {
  backend        = vault_auth_backend.approle.path
  role_name      = "pki-issue-all"
  token_policies = ["pki-issue-all"]
  token_ttl      = 300

  # Not something you would usually do in Production
  # but simplifies things for the demonstration
  bind_secret_id = false
  role_id        = "pki-issue-all"
}
