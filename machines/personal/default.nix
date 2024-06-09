{ pkgs, ... }:
let
  username = "who";
  homeDirectory = "/Users/${username}";
  hm-module = { ... }: {
    home = {
      inherit username homeDirectory;
      stateVersion = "21.05";
      sessionPath = [ "$HOME/.local/bin" ];
    };

    macos-dock.enable = true;

    programs.git = {
      userName = "Walfie";
      userEmail = "walfington@gmail.com";

      extraConfig = {
        url."git@github.com:".insteadOf = "https://github.com";
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "${homeDirectory}/.ssh/id_ed25519.pub";
      };
    };

    programs.zsh.shellAliases = {
      bazel = "bazelisk";
    };

    programs.ssh = {
      enable = true;
      extraOptionOverrides = {
        IgnoreUnknown = "UseKeychain";
      };

      matchBlocks = {
        "github.com" = {
          user = "git";
          hostname = "github.com";
          identityFile = "~/.ssh/id_ed25519";
          identitiesOnly = true;
          extraOptions = {
            UseKeychain = "yes";
            AddKeysToAgent = "yes";
          };
        };
      };
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
      pkgs.ncdu
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
  };
in
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
    hm-module
  ];
}
