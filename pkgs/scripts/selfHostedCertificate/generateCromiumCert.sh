#!/run/current-system/sw/bin/env nix-shell
#!nix-shell -i bash -p openssl

mkdir -p "certs/root"
cd "certs/root" || exit

openssl pkcs12 -export -inkey ./rootCA.key -in ./rootCA.crt -out ./chromeCA.p12