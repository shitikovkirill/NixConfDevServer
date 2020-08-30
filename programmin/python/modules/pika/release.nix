with import <nixpkgs> {};

( let
    pika = callPackage ./default.nix {
      buildPythonPackage = python3Packages.buildPythonPackage;
      fetchPypi = python3Packages.fetchPypi;
    };
  in python3.withPackages (ps: [ pika ])
).env