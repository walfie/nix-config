{ config, pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    secureSocket = false;
    shortcut = "a";
    terminal = "screen-256color";

    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.yank
    ];

    extraConfig = lib.fileContents ./tmux.conf;
  };
}
