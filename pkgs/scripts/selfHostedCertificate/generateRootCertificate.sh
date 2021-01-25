#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -i bash -p openssl

mkdir -p "certs/root"
cd "certs/root" || exit

openssl genrsa -des3 -out rootCA.key 2048

openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1825 -out rootCA.pem