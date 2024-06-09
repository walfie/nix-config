{ pkgs, ... }:
{
  home.packages = [
    pkgs.nodejs
    pkgs.nodePackages.pnpm
    pkgs.yarn
  ];
}
