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
