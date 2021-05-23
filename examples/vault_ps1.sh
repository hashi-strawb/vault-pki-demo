#!/bin/bash

function vault_ps1() {
	if [ -f ~/.vault-token ]; then
		VAULT_WHOAMI=$(vault read --field=display_name auth/token/lookup-self 2>/dev/null)
	fi

	if [[ "${VAULT_WHOAMI}" == "" ]]; then
		echo "(V|https://demo.vault.lmhd.aws.hashicorp.cloud:8200)"
	else
		echo "(V|${VAULT_WHOAMI}@https://demo.vault.lmhd.aws.hashicorp.cloud:8200)"
	fi
}


export PS1='\n$(vault_ps1)\n\w $ '

alias vi=vim
