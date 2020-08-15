with import <nixpkgs> { };
with python38Packages;
(let ipython = callPackage ./ipytest.nix { };
in python38.withPackages (ps: [ ipython ])).env
