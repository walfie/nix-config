{
  description = "Overlay for (Neo)vim plugins";

  inputs = {
    vim-ctrlsf = { url = "github:dyng/ctrlsf.vim"; flake = false; };
    pico8-vim = { url = "github:Bakudankun/PICO-8.vim"; flake = false; };
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
