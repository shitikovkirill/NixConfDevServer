{ config, lib, pkgs, ... }:

let
  vars = import ../../../variables.nix;
  db = import ./load-db.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devPostgres = {
    enable = true;
    domain = "db." + mainDomain;
    database = db.database;
    databases = db.databases;
  };
}
