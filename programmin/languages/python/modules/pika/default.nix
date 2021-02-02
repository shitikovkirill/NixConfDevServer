{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pika";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gqx9avb9nwgiyw5nz08bf99v9b0hvzr1pmqn9wbhd2hnsj6p9wz";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://pika.readthedocs.io/en/stable/";
    description =
      "Pika is a pure-Python implementation of the AMQP 0-9-1 protocol";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
