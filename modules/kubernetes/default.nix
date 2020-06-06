{ pkgs, ... }:
let
  # Download `kubectl-repl` and wrap it with `rlwrap`
  kubectl-repl = pkgs.stdenv.mkDerivation {
    name = "kubectl-repl";
    version = "1.7";
    # TODO: Different URL for Linux
    src = pkgs.fetchurl {
      url = "https://github.com/clusterise/kubectl-repl/releases/download/1.7/kubectl-repl-darwin-amd64-1.7";
      sha256 = "0qgjzxbf4gjg1z9mpqwb8z52gvm0wk1862l4jghks2gdvx6w733l";
    };
    buildInputs = [
      pkgs.makeWrapper
      pkgs.rlwrap
    ];
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/kubectl-repl-unwrapped
      chmod +x $out/bin/kubectl-repl-unwrapped
      makeWrapper ${pkgs.rlwrap}/bin/rlwrap $out/bin/kubectl-repl \
        --argv0 kubectl-repl \
        --add-flags $out/bin/kubectl-repl-unwrapped
    '';
  };
in
{
  primary-user.home-manager.home.packages = [
    kubectl-repl

    pkgs.fzf
    pkgs.kubectl
    pkgs.kubectx
  ];
}
