{ pkgs ? import <nixpkgs> { } }:

let
  stdenv = pkgs.stdenv;
  description = "Bringing MySQL to the web";
in stdenv.mkDerivation rec {
  pname = "phpmyadmin";
  version = "5.1.0-rc1";

  src = pkgs.fetchurl {
    url =
      "https://files.phpmyadmin.net/phpMyAdmin/${version}/phpMyAdmin-${version}-all-languages.zip";
    sha256 = "09mlna69skxr50l3qm72w81wfv0by3ckxl7ysifp1ajb6gdngs7z";
  };

  phases = "unpackPhase";

  buildInputs = with pkgs; [ unzip ];

  targetPath = "$out";

  unpackPhase = ''
    mkdir -p ${targetPath}
    unzip ${src}
    cp -r phpMyAdmin-${version}-all-languages/* ${targetPath}
  '';

  meta = with stdenv.lib; {
    inherit description;
    homepage = "https://www.phpmyadmin.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ shitikovkirill ];
    platforms = platforms.x86_64;
  };
}
