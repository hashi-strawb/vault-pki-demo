# Vault PKI Demonstration

This repo exists as a demonstration of how to quickly set up a Vault Server, and configure it as a PKI Certificate Authority.

It includes some example use-cases, and demonstrations of functionality.

These instructions are aimed to get Vault up and running as quickly as possible, so you can experiment with the functionality.

If you want to see how to configure things yourself, you can read [Build Your Own Certificate Authority (CA)](https://learn.hashicorp.com/tutorials/vault/pki-engine) on the [HashiCorp Learn](https://learn.hashicorp.com/) platform.


## Prerequisites

Some examples in this repository use Docker.

If you do not have Docker installed, you can get it here: https://docs.docker.com/get-docker/

# Setup

These instructions will show you how to set up and configure a new Vault cluster

1. [Setup Vault](setup/000_hcp_vault.md)
2. [Configure Vault](setup/000_configure_vault.md)

# Examples

TODO: Example use cases

* [ ] Creating Certs with UI
* [ ] Different certs with different properties
* [ ] Policies grant access to different roles
* [ ] local nginx example (https://localhost) - with curl, with browser
* [ ] nginx with Vault Agent
* [ ] Revoking PKI Certs
* [ ] Client Certs
