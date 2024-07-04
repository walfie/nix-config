{ pkgs, ... }:
let
  username = "who";
  homeDirectory = "/Users/${username}";
in
{
  imports = [
    ../../modules/bash
    ../../modules/direnv
    ../../modules/fish
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
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "21.05";
    sessionPath = [ "$HOME/.local/bin" ];
  };

  macos-dock.enable = true;
  programs.zoxide.enable = true;

  programs.nix-index-database.comma.enable = true;
  programs.kitty.settings.shell = "${pkgs.fish}/bin/fish";
  programs.tmux = {
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = "set -g default-command ${pkgs.fish}/bin/fish";
  };

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

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      update_check = false;
      enter_accept = false;
    };
  };

  home.packages = [
    pkgs.nixFlakes

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
    pkgs.pngquant

    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    pkgs.ripgrep
    pkgs.bat # cat alternative
    pkgs.choose # Simple cut/awk alternative
    pkgs.jc # Convert the output of multiple commands to JSON
    pkgs.jless # JSON pager
    pkgs.moreutils # sponge: Soak up the input before writing the output file
  ];
}
