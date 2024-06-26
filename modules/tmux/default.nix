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
    historyLimit = 50000;
    sensibleOnTop = true;

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
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '20' # minutes
        '';
      }
      {
        plugin = tmuxPlugins.extrakto;
        extraConfig = ''
          set -g @extrakto_grab_area "window recent"
        '';
      }
    ];

    extraConfig = lib.fileContents ./tmux.conf;
  };
}
