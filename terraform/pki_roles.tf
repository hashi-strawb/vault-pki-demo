#
# Medium Length Certs
#

resource "vault_pki_secret_backend_role" "localhost" {
  backend         = vault_mount.pki_inter.path
  name            = "localhost"
  allow_localhost = "true"

  # 32/90 Days
  ttl     = 60 * 60 * 24 * 32
  max_ttl = 60 * 60 * 24 * 90
}

resource "vault_pki_secret_backend_role" "prod" {
  backend         = vault_mount.pki_inter.path
  name            = "prod.fancycorp.io"
  allow_localhost = "false"

  allow_subdomains = true
  allowed_domains  = ["prod.fancycorp.io"]

  # 32/90 Days
  ttl     = 60 * 60 * 24 * 32
  max_ttl = 60 * 60 * 24 * 90
}

resource "vault_pki_secret_backend_role" "test" {
  backend         = vault_mount.pki_inter.path
  name            = "test.fancycorp.io"
  allow_localhost = "false"

  allow_subdomains = true
  allowed_domains  = ["test.fancycorp.io"]

  # 32/90 Days
  ttl     = 60 * 60 * 24 * 32
  max_ttl = 60 * 60 * 24 * 90
}

resource "vault_pki_secret_backend_role" "dev" {
  backend         = vault_mount.pki_inter.path
  name            = "dev.fancycorp.io"
  allow_localhost = "false"

  allow_subdomains = true
  allowed_domains  = ["dev.fancycorp.io"]

  # 32/90 Days
  ttl     = 60 * 60 * 24 * 32
  max_ttl = 60 * 60 * 24 * 90
}

#
# Short Length Certs
#

resource "vault_pki_secret_backend_role" "localhost_short" {
  backend         = vault_mount.pki_inter.path
  name            = "localhost_short"
  allow_localhost = "true"

  # 1/5 Minutes
  ttl     = 60 * 1
  max_ttl = 60 * 5
}

