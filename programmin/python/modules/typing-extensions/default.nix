{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "typing-extensions";
  version = "3.7.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gqx9avb9nwgiyw5nz08bf99v9b0hvzr1pmqn9wbhd2hnsj6p9w1";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/typing-extensions/";
    description =
      "Typing Extensions – Backported and Experimental Type Hints for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
