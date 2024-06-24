{ pkgs, ... }:
{
  home = {
    # Use our configured nvim from `flakes/nixvim-config` in this repo
    packages = [ pkgs.nixvim.nvim ];
    sessionVariables.EDITOR = "nvim";
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
  };
}
