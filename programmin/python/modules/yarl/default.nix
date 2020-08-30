{ lib, buildPythonPackage, fetchPypi, callPackage }:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mn3avw5hnx31j03f6z0qx6q0glaw18saph40mqx9wwlyfspab62";
  };

  doCheck = false;

  buildInputs = let
    multidict =
      callPackage ../multidict { inherit buildPythonPackage fetchPypi; };

    idna = callPackage ../idna { inherit buildPythonPackage fetchPypi; };
  in [ multidict idna ];

  meta = with lib; {
    homepage = "https://pypi.org/project/yarl/";
    description = "Url is constructed from str";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
