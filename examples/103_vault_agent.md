# Vault Agent

Generating a certificate through the Vault CLI works, but it's a bit tedious.

Well, thankfully, Vault also has the ability to automate that entire thing. There’s a feature called Vault Agent which will automatically get your secrets and store them wherever you like.

If we launch the NGINX + Vault Agent container, we can see it in action:

```
docker-compose run agent
```

Let's take a look at the Vault Agent config file:

```
$ cat vault_agent.hcl
auto_auth {
  method "approle" {
    config = {
      role_id_file_path   = "role-id.txt"
      secret_id_file_path = "secret-id.txt"
    }
  }
}

template {
  contents = <<EOF
{{ with secret "pki/inter/issue/localhost" "common_name=localhost" "ttl=30" }}
{{ toJSONPretty .Data }}
{{ end }}
EOF

  destination = "localhost.json"

  command = "./split-cert.sh"
}
```

There is more we can include in the config, but this is the bare minimum.

The first part of it, [auto_auth](https://www.vaultproject.io/docs/agent/autoauth), defines how Vault Agent will authenticate with Vault.

In this case, we're using the AppRole [defined in Terraform](https://github.com/lucymhdavies/vault-pki-demo/blob/main/terraform/approles.tf).

This has a policy `pki-issue-all` which allows access to generate any PKI Cert using our `pki/inter` Secret Engine.

Next we define a [template](https://www.vaultproject.io/docs/agent/template), which specifies which secrets Vault Agent should read, and where it should store the result. In this case, it's issuing a localhost certificate, valid for 30 seconds, and storing the entire response from vault in a file `localhost.json`.

This file contains the Certificate, the CA Certificate, and the Private Key.

As we are running an NGINX webserver, we want these two to be in different files, so the next thing Vault agent does is run a script `split-cert.sh`:

```
$ cat split-cert.sh
#!/bin/bash
cat localhost.json | jq -r '.certificate, .issuing_ca' > /etc/nginx/localhost.crt
cat localhost.json | jq -r '.private_key' > /etc/nginx/localhost.key

nginx -s reload
```

This script will take the relevant components out of that JSON file and store them in the right place for NGINX to consume them. It then tells NGINX to reload it's configuration, to pick up the new certificates.


If we attempt to read from the webserver right now, on HTTPS, it will not work:

```
$ curl https://localhost
curl: (7) Failed to connect to localhost port 443: Connection refused
```

But if we run Vault Agent, in this case running in the background...

```
$ vault agent -config vault_agent.hcl &
[1] 76
==> Vault agent started! Log data will stream in below:

==> Vault agent configuration:

                     Cgo: disabled
               Log Level: info
                 Version: Vault v1.7.0
             Version Sha: 4e222b85c40a810b74400ee3c54449479e32bb9f

2021-05-28T14:37:05.569Z [INFO]  sink.server: starting sink server
2021-05-28T14:37:05.569Z [INFO]  auth.handler: starting auth handler
2021-05-28T14:37:05.569Z [INFO]  auth.handler: authenticating
2021-05-28T14:37:05.569Z [INFO]  template.server: starting template server
[INFO] (runner) creating new runner (dry: false, once: false)
[INFO] (runner) creating watcher
2021-05-28T14:37:05.811Z [INFO]  auth.handler: authentication successful, sending token to sinks
2021-05-28T14:37:05.811Z [INFO]  auth.handler: starting renewal process
2021-05-28T14:37:05.812Z [INFO]  template.server: template server received new token
[INFO] (runner) stopping
[INFO] (runner) creating new runner (dry: false, once: false)
[INFO] (runner) creating watcher
[INFO] (runner) starting
2021-05-28T14:37:05.854Z [INFO]  auth.handler: renewed auth token
[INFO] (runner) rendered "(dynamic)" => "localhost.json"
[INFO] (runner) executing command "./split-cert.sh" from "(dynamic)" => "localhost.json"
[INFO] (child) spawning: ./split-cert.sh
```

Then it will authenticate with Vault, generate the cert from Vault, and reload it into NGINX.

So now, if we try to run curl...

```
$ curl -v https://localhost

...

* Server certificate:
*  subject: CN=localhost
*  start date: May 28 14:37:29 2021 GMT
*  expire date: May 28 14:38:29 2021 GMT
*  subjectAltName: host "localhost" matched cert's "localhost"
*  issuer: CN=Vault Intermediary CA
*  SSL certificate verify ok.

...

Hello, FancyCorp
* Connection #0 to host localhost left intact
```

It works. And we can actually see the certificate is only valid for 1 minute. You don’t need it this short in reality, but it does make it easier to see what Vault Agent does next.

If we leave it a few seconds, then because I’ve given this an artificially short TTL, Vault Agent will request a new cert from Vault whenever it needs one:

```
[INFO] (runner) rendered "(dynamic)" => "localhost.json"
[INFO] (runner) executing command "./split-cert.sh" from "(dynamic)" => "localhost.json"
[INFO] (child) spawning: ./split-cert.sh
```

So this means you can for the most part just set it and forget it. No more manually renewing certificates for you.
