{ pkgs ? import <nixpkgs> { } }:
with pkgs;

let
pkgsOld = let
    hostPkgs = import <nixpkgs> {};
    pinnedPkgs = hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "120b013e0c082d58a5712cde0a7371ae8b25a601";
      sha256 = "0hk4y2vkgm1qadpsm4b0q1vxq889jhxzjx3ragybrlwwg54mzp4f";
    };
  in import pinnedPkgs {};
in bundlerApp {
  ruby = pkgsOld.ruby;
  pname = "redmon";
  gemdir = ./.;
  exes = [ "redmon" ];
}
