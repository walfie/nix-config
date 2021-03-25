# Useful article on setting up vim in nix
# http://ivanbrennan.nyc/2018-05-09/vim-on-nixos
{ config, pkgs, lib, ... }:
let
  sources = import ../../nix/sources.nix;

  # These plugins aren't in nixpkgs, so load them from niv-managed sources
  mkPlugin = name: pkgs.vimUtils.buildVimPlugin {
    inherit name;
    src = sources.${name};
  };

  customPlugins = builtins.map mkPlugin [
    "vim-argwrap"
    "vim-bbye"
    "vim-ctrlsf"
    "vim-minibufexpl"
  ];
in
{
  home = {
    packages = [
      pkgs.fzf
      pkgs.ripgrep
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON {
    rust-analyzer = {
      serverPath = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      "rustfmt.overrideCommand" = "${pkgs.rustfmt}/bin/rustfmt";
    };

    languageserver.nix = {
      command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
      filetypes = [ "nix" ];
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    configure = {
      customRC = lib.fileContents ./vimrc;
      packages.neovim-with-plugins = with pkgs.vimPlugins; {
        start = [
          coc-nvim # Must be loaded before coc-nvim extensions
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
          vim-scala
          vim-sleuth
          vim-surround
          vim-visual-increment
          zenburn
        ] ++ customPlugins;

        opt = [
          coc-css
          coc-html
          coc-json
          coc-rust-analyzer
        ];
      };
    };
  };
}
