{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "8.14";
  name = "checkstyle-${version}";

  src = fetchurl {
    url = "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar";
    sha256 = "11lpyjh0rbz8821q0gcrll5ichf8hrmlfy66ary5jjiyxc85z762";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  unpackPhase = ":";

  installPhase = ''
    runHook preInstall
    install -D $src $out/checkstyle/checkstyle-all.jar
    makeWrapper ${jre}/bin/java $out/bin/checkstyle \
      --add-flags "-jar $out/checkstyle/checkstyle-all.jar"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Checks Java source against a coding standard";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
    homepage = http://checkstyle.sourceforge.net/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
