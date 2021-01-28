if builtins.pathExists ./secrets.nix then
  import ./secrets.nix
else {
  github_token = "";
  aws_access_key_id = "";
  aws_secret_access_key = "";
  digital_ocean = "";
}
