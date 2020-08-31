{ lib, buildPythonPackage, fetchPypi, callPackage }:

buildPythonPackage rec {
  pname = "aiormq";
  version = "3.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jcmrily67is933a71rjbdngh00fr2mfhn3bqkv1m77i6sl9arhh";
  };

  propagatedBuildInputs = let
    pamqp = callPackage ../pamqp { inherit buildPythonPackage fetchPypi; };

    yarl = callPackage ../yarl { inherit buildPythonPackage fetchPypi; };
  in [ pamqp yarl ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/aiormq/";
    description = "aiormq is a pure python AMQP client library.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
