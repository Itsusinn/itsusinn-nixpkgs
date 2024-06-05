{
  lib,
  stdenv,
  fetchzip,
  ...
}: let
  pkgver = "4.14.4";
in
  stdenv.mkDerivation rec {
    pname = "uuplugin";
    version = "0.1.1";
    src = fetchzip {
      stripRoot = false;
      url = "https://github.com/Itsusinn/frozen-binaries/releases/download/uuplugin-${pkgver}/uu.tar.gz";
      hash = "sha256-WJ1wimHzs5BBQ+rRnePwTlnPukIX772UF7JG7hJUHek=";
    };

    installPhase = ''
      runHook preInstall
      install -m755 -D uuplugin $out/bin/uuplugin
      runHook postInstall
    '';

    meta = with lib; {
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ itsusinn ];
      mainProgram = "uuplugin";
    };
  }