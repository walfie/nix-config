{ pkgs, ... }:
let
  kubectl-repl = pkgs.callPackage ./kubectl-repl.nix {};

  # Grep for pods
  kubectl-getg = pkgs.writeShellScriptBin "kubectl-getg" ''
    export PATH=${pkgs.stdenv.lib.makeBinPath [ pkgs.kubectl pkgs.gnugrep ]}
    last=''${@:$#} # last parameter
    other=''${*%''${!#}} # all parameters except the last

    kubectl get pods $last | grep $other
  '';

  # Like `kubectl logs`, but attempt to parse the line as JSON
  kubectl-lg = pkgs.writeShellScriptBin "kubectl-lg" ''
    export PATH=${pkgs.stdenv.lib.makeBinPath [ pkgs.kubectl pkgs.jq ]}
    kubectl logs --tail 100 $@ \
      | jq -Rr '. as $line | try (fromjson | "\(.["@timestamp"]) \(.level) \(.logger_name) \(.message) \(.stack_trace // "")") catch $line'
  '';
in
{
  primary-user.home-manager.home = {
    sessionVariables = {
      KUBECONFIG = builtins.concatStringsSep ":" [
        "$HOME/.kube/kirakiratter-kubeconfig.yaml"
        "$HOME/.kube/config"
        "$KUBECONFIG"
      ];
    };

    packages = [
      kubectl-repl
      kubectl-getg
      kubectl-lg

      pkgs.fzf
      pkgs.kubectl
      pkgs.kubectx
    ];
  };
}