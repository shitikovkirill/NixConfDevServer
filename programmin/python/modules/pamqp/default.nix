{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pamqp";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s4lwbsiikz3czqad7jarb7k303q0wamla0rirghvwl9bslgbl2w";
  };

  doCheck = false;

  meta = with lib; {
    homepage = https://pika.readthedocs.io/en/stable/;
    description = "Pika is a pure-Python implementation of the AMQP 0-9-1 protocol";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}