{ pkgs, lib, ... }:
{
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;
      settings = {
        fzf_bin = "${pkgs.skim}/bin/sk";
        fzf_opts = {
          "--layout" = "default";
          "--border" = false;
          "--no-separator" = false;
        };
        winopts = {
          width = 0.9;
          preview.hidden = "hidden";
        };
      };
    };

    extraConfigLua = lib.fileContents ../lua/fzf-lua.lua;
  };
}
