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
{{ with secret "pki/inter/issue/localhost" "common_name=localhost" "ttl=30" }}{{ .Data.certificate }}
{{ .Data.issuing_ca }}{{ end }}
EOF

  destination = "/etc/nginx/localhost.crt"

  command = "nginx -s reload"
}

template {
  contents = <<EOF
{{ with secret "pki/inter/issue/localhost" "common_name=localhost" "ttl=30" }}{{ .Data.private_key }}{{ end }}
EOF

  destination = "/etc/nginx/localhost.key"
}
