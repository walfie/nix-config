{ pkgs, lib, ... }:
let
  kubectl-repl = pkgs.callPackage ./kubectl-repl.nix { };

  # Grep for pods
  kubectl-getg = pkgs.writeShellScriptBin "kubectl-getg" ''
    export PATH=${lib.makeBinPath [ pkgs.kubectl pkgs.gnugrep ]}:$PATH
    last=''${@:$#} # last parameter
    other=''${*%''${!#}} # all parameters except the last
    kubectl get pods $last | grep $other
  '';

  # Like `kubectl logs`, but attempt to parse the line as JSON
  kubectl-lg = pkgs.writeShellScriptBin "kubectl-lg" ''
    export PATH=${lib.makeBinPath [ pkgs.kubectl pkgs.jq ]}:$PATH
    kubectl logs --tail 100 $@ \
      | jq -Rr '. as $line | try (fromjson | "\(.["@timestamp"]) \(.level) \(.logger_name) \(.message) \(.stack_trace // "")") catch $line'
  '';

  # kubectx except it supports multiple kubeconfig files
  kubectx = pkgs.writeShellScriptBin "kubectx" ''
    export PATH=${lib.makeBinPath [ pkgs.kubectl pkgs.fzf ]}:$PATH
    kubectl config use-context $(kubectl config get-contexts -o name | fzf)
  '';
in
{
  home = {
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
      kubectx

      pkgs.kubectl
    ];
  };
}
