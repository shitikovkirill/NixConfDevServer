{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  nixpkgs.config.allowUnsupportedSystem = true;

  services.devRedis = { enable = true; };
}
