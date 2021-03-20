{ config, pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    shortcut = "a";
    secureSocket = false;
    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.sensible
      tmuxPlugins.yank
    ];

    extraConfig = lib.fileContents ./tmux.conf;
  };
}
