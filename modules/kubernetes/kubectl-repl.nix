{ stdenv, fetchurl, makeWrapper, rlwrap, ... }:

# Download `kubectl-repl` and wrap it with `rlwrap`
#
# Useful guide for adding custom packages:
# https://github.com/LnL7/nix-darwin/issues/16#issuecomment-284262711
let
  version = "1.7";

  meta = if stdenv.isDarwin then {
    arch = "darwin-amd64";
    sha256 = "0qgjzxbf4gjg1z9mpqwb8z52gvm0wk1862l4jghks2gdvx6w733l";
  } else {
    arch = "linux-amd64";
    sha256 = "01f2yvdgzi7xanhv7zxpsr0m99hric7a5lfi5bspfc031i4fb8br";
  };

  url = "https://github.com/clusterise/kubectl-repl/releases/download/${version}/kubectl-repl-${meta.arch}-${version}";
in
stdenv.mkDerivation {
  inherit version;
  name = "kubectl-repl";
  buildInputs = [ makeWrapper rlwrap ];
  dontUnpack = true;
  dontBuild = true;
  src = fetchurl {
    inherit url;
    sha256 = meta.sha256;
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/kubectl-repl-unwrapped
    chmod +x $out/bin/kubectl-repl-unwrapped
    makeWrapper ${rlwrap}/bin/rlwrap $out/bin/kubectl-repl \
      --argv0 kubectl-repl \
      --add-flags $out/bin/kubectl-repl-unwrapped
  '';
}
