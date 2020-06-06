{ pkgs, ... }:
let
  kubectl-repl = pkgs.callPackage ./kubectl-repl.nix {};
in
{
  primary-user.home-manager.home.packages = [
    kubectl-repl

    pkgs.fzf
    pkgs.kubectl
    pkgs.kubectx
  ];
}
