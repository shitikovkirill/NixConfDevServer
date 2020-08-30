{ lib, buildPythonPackage, fetchPypi, callPackage }:

buildPythonPackage rec {
  pname = "aiormq";
  version = "3.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jcmrily67is933a71rjbdngh00fr2mfhn3bqkv1m77i6sl9arhh";
  };

  buildInputs = let
    pamqp = callPackage ../pamqp { inherit buildPythonPackage fetchPypi; };

    yarl = callPackage ../yarl { inherit buildPythonPackage fetchPypi; };

    multidict =
      callPackage ../multidict { inherit buildPythonPackage fetchPypi; };

    idna = callPackage ../idna { inherit buildPythonPackage fetchPypi; };
    typing-extensions = callPackage ../typing-extensions { inherit buildPythonPackage fetchPypi; };
  in [ pamqp yarl multidict idna typing-extensions ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/aiormq/";
    description = "aiormq is a pure python AMQP client library.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}