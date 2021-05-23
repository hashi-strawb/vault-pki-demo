FROM vault
RUN apk add curl openssl nginx bash vim
ADD entrypoint.sh /entrypoint.sh
ADD vault_ps1.sh /etc/profile.d/vault_ps1.sh
ENTRYPOINT ["/entrypoint.sh"]
