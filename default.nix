{ pkgs, prefix, ... }:

{
  imports = [
    ./home-manager
    ./system
    ./pkgs
    ./programmin/load-profile.nix
  ];

  environment.systemPackages = with pkgs; [ home-manager ];
}

