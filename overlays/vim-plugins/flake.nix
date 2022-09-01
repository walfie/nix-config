{
  description = "Overlay for (Neo)vim plugins";

  inputs = {
    vim-ctrlsf.url = "github:dyng/ctrlsf.vim";
    vim-ctrlsf.flake = false;
    vim-minibufexpl.url = "github:weynhamz/vim-plugin-minibufexpl";
    vim-minibufexpl.flake = false;
  };

  outputs = inputs: {
    overlays.default = final: prev:
      let
        mkVimPlugin = name: src: prev.vimUtils.buildVimPlugin { inherit name src; };
      in
      {
        vimPlugins = prev.vimPlugins // (builtins.mapAttrs mkVimPlugin inputs);
      };
  };
}
