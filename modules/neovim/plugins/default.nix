{ pkgs, lib, ... }:
{
  imports = [
    ./plugins/barbar.nix
    ./plugins/camelcasemotion.nix
    ./plugins/cmp.nix
    ./plugins/lsp.nix
    ./plugins/neo-tree.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    extraPlugins = with pkgs.vimPlugins; [
      camelcasemotion
      nerdcommenter
      nvim-web-devicons
      traces-vim
      vim-abolish
      vim-eunuch
      vim-repeat
      vim-scala
      vim-visual-increment
    ];

    extraConfigLua = lib.fileContents ./lua/init.lua;

    plugins = {
      emmet.enable = true;
      fugitive.enable = true;
      sleuth.enable = true;
      surround.enable = true;
      which-key.enable = true;
      nvim-autopairs.enable = true;
      rainbow-delimiters.enable = true;
      neo-tree.enable = true;
      treesitter.enable = true;
    };
  };
}
