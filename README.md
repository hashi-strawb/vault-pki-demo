# Vault PKI Demonstration

This repo exists as a demonstration of how to quickly set up a Vault Server, and configure it as a PKI Certificate Authority.

These instructions are aimed to get Vault up and running as quickly as possible, so you can experiment with the functionality.

If you want to see how to configure things yourself, you can read [Build Your Own Certificate Authority (CA)](https://learn.hashicorp.com/tutorials/vault/pki-engine) on the [HashiCorp Learn](https://learn.hashicorp.com/) platform.


## Prerequisites

Some examples in this repository use Docker.

If you do not have Docker installed, you can get it here: https://docs.docker.com/get-docker/

# Setup

These instructions will show you how to set up and configure a new Vault cluster

1. [Setup Vault](setup/000_hcp_vault.md)
2. [Configure Vault](setup/001_configure_vault.md)

# Examples

1. TODO: [PKI in UI](examples/100_pki_ui.md)
2. TODO: [PKI via CLI](examples/101_pki_cli.md)
3. TODO: [Webserver Example](examples/102_webserver.md)
4. [Webserver with Vault Agent](examples/103_vault_agent.md)
