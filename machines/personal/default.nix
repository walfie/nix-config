{ pkgs, ... }:
{
  inherit pkgs;

  modules = [
    ../../modules/bash
    ../../modules/direnv
    ../../modules/flakes
    ../../modules/git
    ../../modules/home-manager
    ../../modules/javascript
    ../../modules/kitty
    ../../modules/kubernetes
    ../../modules/macos
    ../../modules/neovim
    ../../modules/rust
    ../../modules/tmux
    ../../modules/xdg
    ../../modules/zsh

    {
      macos-dock.enable = true;

      programs.git = {
        userName = "Walfie";
        userEmail = "walfington@gmail.com";
      };

      programs.zsh.shellAliases = {
        bazel = "bazelisk";
      };

      home = {
        stateVersion = "21.05";
        username = "who";
        homeDirectory = "/Users/who";
        sessionPath = [ "$HOME/.local/bin" ];
      };

      home.packages = [
        pkgs.bazelisk
        pkgs.bazel-buildtools
        pkgs.coreutils # Use GNU versions of `ls`, etc
        pkgs.doctl
        pkgs.fd
        pkgs.ffmpeg
        pkgs.gnused
        pkgs.gron
        pkgs.htop
        pkgs.imagemagick
        pkgs.inetutils
        pkgs.jq
        #pkgs.ncdu # Broken. Fixed in https://github.com/NixOS/nixpkgs/issues/290512
        pkgs.niv
        pkgs.nixpkgs-fmt
        pkgs.oci-cli # Oracle Cloud
        pkgs.pngcrush
        pkgs.pup
        pkgs.rename
        pkgs.rlwrap
        pkgs.sqlite
        pkgs.tealdeer
        pkgs.tree
        pkgs.trunk
        pkgs.wget
        pkgs.rust-bindgen
        pkgs.optipng
      ];
    }
  ];
}
