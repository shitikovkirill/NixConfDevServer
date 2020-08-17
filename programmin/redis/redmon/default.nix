{ pkgs ? import <nixpkgs> { } }:
with pkgs;

bundlerApp {
  pname = "redmon";
  gemdir = ./.;
  exes = [ "redmon" ];
}
