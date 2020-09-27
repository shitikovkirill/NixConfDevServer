{ pkgs, prefix, ... }:

{
  imports = [ ./home-manager ./system ./pkgs ./programmin/load-profile.nix ];
}

