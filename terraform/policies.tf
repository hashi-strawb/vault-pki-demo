resource "vault_policy" "pki-issue-all" {
  name = "pki-issue-all"

  policy = <<EOT
# List enabled secret engines
path "sys/mounts" {
  capabilities = [ "read", "list" ]
}

# Issue certificates from any Role
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

resource "vault_policy" "pki-issue-some" {
  name = "pki-issue-some"

  policy = <<EOT
# List enabled secret engines
path "sys/mounts" {
  capabilities = [ "read", "list" ]
}

# Issue certificates from some roles
path "pki/inter/issue/test.fancycorp.io" {
  capabilities = ["update"]
}

# Issue certificates from some roles
path "pki/inter/issue/dev.fancycorp.io" {
  capabilities = ["update"]
}

# Read details from some PKI Roles
path "pki/inter/roles/test.fancycorp.io" {
  capabilities = ["read"]
}

# Read details from some PKI Roles
path "pki/inter/roles/dev.fancycorp.io" {
  capabilities = ["read"]
}

# List all PKI Roles
path "pki/inter/roles" {
  capabilities = ["list"]
}
EOT
}


