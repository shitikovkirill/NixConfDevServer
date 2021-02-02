{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "idna";
  version = "2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xmk3s92d2vq42684p61wixfmh3qpr2mw762w0n6662vhlpqf1xk";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/idna/";
    description =
      "Support for the Internationalised Domain Names in Applications (IDNA) protocol as specified in RFC 5891";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
