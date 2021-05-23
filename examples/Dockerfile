FROM vault:1.7.0
RUN apk add curl openssl nginx bash vim
ADD entrypoint.sh /entrypoint.sh
ADD vault_ps1.sh /etc/profile.d/vault_ps1.sh
ADD hello.conf /etc/nginx/conf.d/default.conf
ADD index.html /usr/share/nginx/html/index.html
ENTRYPOINT ["/entrypoint.sh"]
