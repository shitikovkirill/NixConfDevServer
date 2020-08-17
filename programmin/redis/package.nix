{ pkgs ? import <nixpkgs> { }, ... }:

{
  name = "moodle";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "tituslearning";
    repo = "moodle-block_homework";
    rev = "e279233201e7292819a111897cc4255e0b6779df";
    sha256 = "15lixxpvzf71nwyvs912cxwz8ix0qvnni6xingh9fa12iy6zsmwi";
  };

  meta = with stdenv.lib; {
    description =
      "Free and open-source learning management system (LMS) written in PHP";
    license = licenses.gpl3Plus;
    homepage = "https://moodle.org/";
    maintainers = with maintainers; [ aanderse ];
    platforms = platforms.all;
  };
}
