# Terraforming the example from here:
# https://learn.hashicorp.com/tutorials/vault/pki-engine


#
# Root CA
#

resource "vault_mount" "pki_root" {
  path = "pki/root"
  type = "pki"

  # 1 day
  default_lease_ttl_seconds = 60 * 60 * 24

  # 10 years
  max_lease_ttl_seconds = 60 * 60 * 24 * 365 * 10
}

resource "vault_pki_secret_backend_config_urls" "pki_root_config_urls" {
  backend                 = vault_mount.pki_root.path
  issuing_certificates    = ["${local.vault_addr}/v1/${local.vault_namespace}/${vault_mount.pki_root.path}/ca"]
  crl_distribution_points = ["${local.vault_addr}/v1/${local.vault_namespace}/${vault_mount.pki_root.path}/crl"]
}



#
# Intermediary CA
#

resource "vault_mount" "pki_inter" {
  path = "pki/inter"
  type = "pki"

  # 1 day
  default_lease_ttl_seconds = 60 * 60 * 24

  # 1 year
  max_lease_ttl_seconds = 60 * 60 * 24 * 365
}

resource "vault_pki_secret_backend_config_urls" "pki_inter_config_urls" {
  backend                 = vault_mount.pki_inter.path
  issuing_certificates    = ["${local.vault_addr}/v1/${local.vault_namespace}/${vault_mount.pki_inter.path}/ca"]
  crl_distribution_points = ["${local.vault_addr}/v1/${local.vault_namespace}/${vault_mount.pki_inter.path}/crl"]
}



#
# Generate Root CA
#

resource "vault_pki_secret_backend_root_cert" "pki_root_cert" {
  depends_on = [vault_mount.pki_root]

  backend = vault_mount.pki_root.path

  type        = "internal"
  common_name = "Vault Root CA"
  ttl         = 60 * 60 * 24 * 365 * 10
}


#
# Generate Inter CSR
#

resource "vault_pki_secret_backend_intermediate_cert_request" "pki_inter" {
  depends_on = [vault_mount.pki_inter]

  backend = vault_mount.pki_inter.path

  type        = "internal"
  common_name = "Vault Intermediary CA"
}



#
# Root signs Inter
#

resource "vault_pki_secret_backend_root_sign_intermediate" "pki_root_inter" {
  depends_on = [vault_pki_secret_backend_intermediate_cert_request.pki_inter]

  backend = vault_mount.pki_root.path

  csr         = vault_pki_secret_backend_intermediate_cert_request.pki_inter.csr
  common_name = "Vault Intermediary CA"
  format      = "pem_bundle"
  ttl         = 60 * 60 * 24 * 365
}


# Set Inter CA

resource "vault_pki_secret_backend_intermediate_set_signed" "pki_inter" {
  backend = vault_mount.pki_inter.path

  certificate = vault_pki_secret_backend_root_sign_intermediate.pki_root_inter.certificate
}

