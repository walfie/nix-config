{
  description = "Overlay for (Neo)vim plugins";

  inputs = {
    vim-ctrlsf.url = "github:dyng/ctrlsf.vim";
    vim-ctrlsf.flake = false;
    nvim-lspconfig.url = "github:neovim/nvim-lspconfig";
    nvim-lspconfig.flake = false;
  };

  outputs = inputs: {
    overlays.default = final: prev:
      let
        mkVimPlugin = name: src: prev.vimUtils.buildVimPlugin { inherit name src; };
      in
      {
        vimExtraPlugins = builtins.mapAttrs mkVimPlugin inputs;
      };
  };
}
