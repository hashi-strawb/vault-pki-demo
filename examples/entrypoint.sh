#!/bin/bash


if [[ ${AUTOLOGIN} ]]; then
	vault login -no-print -method=userpass username=pki_all password=superSecretPassword
fi

if [[ ${AUTO_TRUST_CA} ]]; then
	curl -s ${VAULT_ADDR}/v1/${VAULT_NAMESPACE}/pki/root/ca/pem  > /etc/ssl/certs/vault_root.pem
	curl -s ${VAULT_ADDR}/v1/${VAULT_NAMESPACE}/pki/inter/ca/pem > /etc/ssl/certs/vault_inter.pem

	echo >> /etc/ssl/certs/ca-certificates.crt
	cat /etc/ssl/certs/vault_root.pem >> /etc/ssl/certs/ca-certificates.crt
	echo >> /etc/ssl/certs/ca-certificates.crt
	cat /etc/ssl/certs/vault_inter.pem >> /etc/ssl/certs/ca-certificates.crt

	update-ca-certificates 2>/dev/null
fi

if [[ ${RUN_NGINX} ]]; then
	mkdir -p /run/nginx
	nginx
fi

bash -l
