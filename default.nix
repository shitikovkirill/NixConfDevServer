{ pkgs, prefix, ... }:

{
  imports = [
    (import "${
        builtins.fetchTarball
        "https://github.com/rycee/home-manager/archive/master.tar.gz"
      }/nixos")
    ./home-manager
    ./system
    ./pkgs
    ./programmin/load-profile.nix
  ];
}

