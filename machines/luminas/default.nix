{ pkgs, system, ... }:
{
  inherit pkgs system;

  stateVersion = "21.05";
  username = "who";
  homeDirectory = "/Users/who";

  configuration = {
    imports = [
      ../../modules/bash
      ../../modules/direnv
      ../../modules/flakes
      ../../modules/git
      ../../modules/javascript
      ../../modules/kitty
      ../../modules/kubernetes
      ../../modules/macos
      ../../modules/neovim
      ../../modules/rust
      ../../modules/tmux
      ../../modules/xdg
      ../../modules/zsh
    ];

    macos-dock.enable = true;

    programs.git = {
      userName = "Walfie";
      userEmail = "walfington@gmail.com";
    };

    home.packages = [
      pkgs.coreutils # Use GNU versions of `ls`, etc
      pkgs.doctl
      pkgs.ffmpeg
      pkgs.gnused
      pkgs.gron
      pkgs.htop
      pkgs.imagemagick
      pkgs.inetutils
      pkgs.jq
      pkgs.ncdu
      pkgs.niv
      pkgs.nixpkgs-fmt
      pkgs.pup
      pkgs.rename
      pkgs.tealdeer
      pkgs.tree
      pkgs.trunk
      pkgs.wget
    ];
  };
}
