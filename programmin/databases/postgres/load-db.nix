if builtins.pathExists ./db.nix then
  import ./db.nix
else {
  database = { };
  databases = [ ];
}
