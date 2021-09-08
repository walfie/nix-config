{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixUnstable
  ];

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';
}

