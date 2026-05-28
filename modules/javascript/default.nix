{ pkgs, ... }:
{
  home.packages = [
    pkgs.nodejs
    pkgs.pnpm
    pkgs.yarn
  ];
}
