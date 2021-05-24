FROM vault:1.7.0
RUN apk add curl openssl nginx bash vim jq
ADD entrypoint.sh /entrypoint.sh
ADD vault_ps1.sh /etc/profile.d/vault_ps1.sh
ADD hello.conf /etc/nginx/conf.d/default.conf
ADD hello.ssl.conf /etc/nginx/conf.d/default.conf.ssl
ADD index.html /usr/share/nginx/html/index.html
ADD vault_agent.hcl /root/vault_agent.hcl
ENTRYPOINT ["/entrypoint.sh"]
