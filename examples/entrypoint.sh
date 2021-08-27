#!/bin/bash


if [[ ${AUTOLOGIN} ]]; then
	vault login -no-print -method=userpass username=pki_all password=superSecretPassword
fi

if [[ ${AUTO_TRUST_CA} ]]; then
	curl -s ${VAULT_ADDR}/v1/${VAULT_NAMESPACE}/pki/root/ca/pem  > /usr/local/share/ca-certificates/vault_root.pem
	update-ca-certificates 2>/dev/null
fi

if [[ ${RUN_NGINX} ]]; then
	mkdir -p /run/nginx
	nginx
fi

if [[ ${VAULT_AGENT} ]]; then
	mv /etc/nginx/conf.d/default.conf.ssl /etc/nginx/conf.d/default.conf

	echo "pki-issue-all" > role-id.txt
	echo "c9b3d349-c0cd-4763-863b-7babaeda82ad" > secret-id.txt
fi

bash -l
