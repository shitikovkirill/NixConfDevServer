{ config, lib, pkgs, ... }:

let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devPostgres = {
    enable = true;
    domain = "mysql." + mainDomain;
    database = { user = "kirill"; };
    databases = ["sessionglobal" "test_sessionglobal"];
  };
}
