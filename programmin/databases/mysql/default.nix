{ config, lib, pkgs, ... }:

let
  vars = import ../../../variables.nix;
  db = import ./load-db.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devMysql = {
    enable = true;
    domain = "mysql." + mainDomain;
    database = db.database;
    databases = db.databases;
  };
}
