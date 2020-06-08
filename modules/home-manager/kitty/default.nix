{ config, pkgs, ... }:
{
  # kitty is managed by home-manager, which creates a symlink to the app in
  # `~/.nix-profile/Applications`, but we want it somewhere in `~/Applications`
  # instead of a hidden directory. This adds it to the system packages so that
  # nix-darwin adds it there.
  #
  # Relevant issues:
  # https://github.com/LnL7/nix-darwin/issues/139
  # https://github.com/NixOS/nix/issues/956
  environment.systemPackages = [ pkgs.kitty ];

  primary-user.home-manager.programs.kitty = {
    enable = true;
    font = {
      package = pkgs.inconsolata;
      name = "Inconsolata";
    };

    keybindings = {
      "super+1" = "goto_tab 1";
      "super+2" = "goto_tab 2";
      "super+3" = "goto_tab 3";
      "super+4" = "goto_tab 4";
      "super+5" = "goto_tab 5";
      "super+6" = "goto_tab 6";
      "super+7" = "goto_tab 7";
      "super+8" = "goto_tab 8";
      "super+9" = "goto_tab 9";
      "super+minus" = "decrease_font_size";
      "super+equal" = "increase_font_size";
    };

    # Config settings: https://sw.kovidgoyal.net/kitty/conf.html
    settings = {
      font_size = "18.0";
      adjust_line_height = 1;
      cursor_blink_interval = 0;
      open_url_modifiers = "super";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      macos_quit_when_last_window_closed = true;
      macos_thicken_font = "0.75";
    };
  };
}
