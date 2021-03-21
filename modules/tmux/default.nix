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
      tmuxPlugins.copycat
      tmuxPlugins.pain-control
      tmuxPlugins.yank

      {
        plugin = tmuxPlugins.resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '${config.xdg.dataHome}/tmux/resurrect'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15' # minutes
        '';
      }
    ];

    extraConfig = lib.fileContents ./tmux.conf;
  };
}
