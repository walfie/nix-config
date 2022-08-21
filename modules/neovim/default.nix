# Useful article on setting up vim in nix
# http://ivanbrennan.nyc/2018-05-09/vim-on-nixos
{ config, pkgs, lib, ... }:
let
  sources = import ../../nix/sources.nix;

  # These plugins aren't in nixpkgs, so load them from niv-managed sources
  mkPlugin = name: pkgs.vimUtils.buildVimPlugin {
    inherit name;
    src = sources.${name};
    dontBuild = true;
  };

  mkOptionalPlugin = plugin: {
    inherit plugin;
    optional = true;
  };

  plugins = with pkgs.vimPlugins; [
    coc-rust-analyzer
    coc-tsserver
    coc-metals

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
    vim-bbye
    vim-eunuch
    vim-fugitive
    vim-nerdtree-tabs
    vim-polyglot
    vim-repeat
    vim-scala
    vim-sleuth
    vim-surround
    vim-visual-increment
    zenburn
  ];

  optionalPlugins = builtins.map mkOptionalPlugin (with pkgs.vimPlugins; [
    coc-css
    coc-html
    coc-json
  ]);

  customPlugins = builtins.map mkPlugin [
    "vim-argwrap"
    "vim-ctrlsf"
    "vim-minibufexpl"
    "vim-rescript"
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    coc = {
      enable = true;

      package = mkPlugin "coc-nvim";

      settings = {
        diagnostic.checkCurrentLine = true;
        metals.javaHome = pkgs.jdk11.home;

        rust-analyzer = {
          serverPath = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          rustfmt.overrideCommand = "${pkgs.rustfmt}/bin/rustfmt";

          # https://users.rust-lang.org/t/can-i-stop-vscode-rust-analyzer-from-shading-out-cfgs/58773
          cargo.allFeatures = true;
        };

        languageserver.nix = {
          command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
          filetypes = [ "nix" ];
        };

        languageserver.rescript = {
          enable = true;
          module = "${sources.vim-rescript}/server/out/server.js";
          args = [ "--node-ipc" ];
          filetypes = [ "rescript" ];
          rootPatterns = [ "bsconfig.json" ];
        };
      };
    };

    plugins = plugins ++ optionalPlugins ++ customPlugins;
    extraConfig = lib.fileContents ./vimrc;
  };
}
