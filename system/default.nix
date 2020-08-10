{ pkgs, prefix, ... }:

{
  time.timeZone = "Europe/Kiev";

  imports = [ ./users.nix ./network.nix ./aliases.nix ];
}
