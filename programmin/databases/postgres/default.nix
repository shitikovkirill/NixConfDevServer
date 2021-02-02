{ config, lib, pkgs, ... }:

let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devPostgres = {
    enable = true;
    domain = "db." + mainDomain;
    database = { user = "kirill"; };
  };
}
