{ lib, buildPythonPackage, fetchPypi, callPackage }:

buildPythonPackage rec {
  pname = "aio-pika";
  version = "6.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rpq47g5xpg1gsnfdqbwf4qn57llrm31hdr7q4dzhyrwbfwbxjy4";
  };

  buildInputs = let
    aiormq = callPackage ../aiormq { inherit buildPythonPackage fetchPypi; };

    pamqp = callPackage ../pamqp { inherit buildPythonPackage fetchPypi; };

    yarl = callPackage ../yarl { inherit buildPythonPackage fetchPypi; };

    multidict =
      callPackage ../multidict { inherit buildPythonPackage fetchPypi; };

    idna = callPackage ../idna { inherit buildPythonPackage fetchPypi; };

    typing-extensions = callPackage ../typing-extensions { inherit buildPythonPackage fetchPypi; };
  in [ aiormq yarl pamqp multidict idna typing-extensions ];

  meta = with lib; {
    homepage = "https://aio-pika.readthedocs.io/en/latest/index.html";
    description =
      "aio-pika is a wrapper for the aiormq for asyncio and humans.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
