{ pkgs ? import <nixpkgs> { } }:
with pkgs;

let
pkgsOld = let
    hostPkgs = import <nixpkgs> {};
    pinnedPkgs = hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      # nixos-unstable as of 2017-11-13T08:53:10-00:00
      rev = "9c31c72cafe536e0c21238b2d47a23bfe7d1b033";
      sha256 = "0pn142js99ncn7f53bw7hcp99ldjzb2m7xhjrax00xp72zswzv2n";
    };
  in import pinnedPkgs {};
in bundlerApp {
  ruby = pkgsOld.ruby;
  pname = "redmon";
  gemdir = ./.;
  exes = [ "redmon" ];
}
