resource "vault_policy" "pki-issue-all" {
  name = "pki-issue-all"

  policy = <<EOT
path "pki/inter/issue/+" {
  capabilities = ["update"]
}

path "pki/inter/roles/+" {
  capabilities = ["read"]
}

path "pki/inter/roles" {
  capabilities = ["list"]
}
EOT
}

