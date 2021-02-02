{ config, pkgs, ... }:
let vars = import ../../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devGitLab = {
    enable = true;
    domain = "gitlab." + mainDomain;
  };
}
