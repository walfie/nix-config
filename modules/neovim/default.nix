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
    # LSP config
    nvim-lspconfig
    rust-tools-nvim

    # LSP completion
    nvim-cmp
    cmp-buffer
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path

    # Other
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

    # Color scheme
    zenburn
  ];

  optionalPlugins = builtins.map mkOptionalPlugin (with pkgs.vimPlugins; [
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
      pkgs.rust-analyzer
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

    plugins = plugins ++ optionalPlugins ++ customPlugins;
    extraConfig = lib.fileContents ./vimrc;
  };
}
