with import <nixpkgs> {};
with pythonPackages;
( let
    ipython = callPackage ./ipytest.nix {};
  in python38.withPackages (ps: [ ipython ])
).env