{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "multidict";
  version = "4.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c0lp75p5z6zmpsy8ar099kj6kggi0yq4kld99y1w0i9wmspmdzv";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/multidict/";
    description = "Multidict is dict-like collection of key-value pairs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
