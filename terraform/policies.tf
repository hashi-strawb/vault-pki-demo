resource "vault_policy" "pki-issue-all" {
  name = "pki-issue-all"

  policy = <<EOT
# List enabled secret engines
path "sys/mounts" {
  capabilities = [ "read", "list" ]
}

# Issue certificates from any CA
path "pki/inter/issue/+" {
  capabilities = ["update"]
}

# Read details for any PKI Role
path "pki/inter/roles/+" {
  capabilities = ["read"]
}

# List all PKI Roles
path "pki/inter/roles" {
  capabilities = ["list"]
}
EOT
}


# TODO: policies for access to specific PKI roles
