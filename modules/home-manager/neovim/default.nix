# Useful article on setting up vim in nix
# http://ivanbrennan.nyc/2018-05-09/vim-on-nixos
{ config, pkgs, lib, ... }:
let
  sources = import ../../../nix/sources.nix;

  # These plugins aren't in nixpkgs, so load them from niv-managed sources
  mkPlugin = name: pkgs.vimUtils.buildVimPlugin {
    inherit name;
    src = sources.${name};
  };

  customPlugins = builtins.map mkPlugin [
    "vim-plugin-minibufexpl"
    "vim-argwrap"
    "vim-bbye"
    "ctrlsf.vim"
  ];
in
{
  primary-user.home-manager.home = {
    packages = [
      pkgs.fzf
      pkgs.ripgrep
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  primary-user.home-manager.xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON {
    rust-analyzer = {
      serverPath = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      "rustfmt.overrideCommand" = "${pkgs.rustfmt}/bin/rustfmt";
    };
  };

  primary-user.home-manager.programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    package = pkgs.neovim.override {
      configure.customRC = lib.fileContents ./vimrc;
      configure.packages.neovim-with-plugins = with pkgs.vimPlugins; {
        start = [
          coc-nvim # Must be loaded before extensions
          coc-rust-analyzer
          camelcasemotion
          delimitMate
          emmet-vim
          fzf-vim
          fzfWrapper
          nerdcommenter
          nerdtree
          rainbow
          traces-vim
          vim-abolish
          vim-eunuch
          vim-nerdtree-tabs
          vim-polyglot
          vim-repeat
          vim-sleuth
          vim-surround
          vim-visual-increment
          zenburn
        ] ++ customPlugins;

        opt = [
          vim-scala
        ];
      };
    };
  };
}
