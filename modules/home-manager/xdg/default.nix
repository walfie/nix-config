{ config, ... }:
{
  # Suggestions taken from:
  # https://wiki.archlinux.org/index.php/XDG_Base_Directory
  primary-user.home-manager.xdg = {
    enable = true;

    dataFile."wgetrc".text = "hsts-file = ${config.primary-user.home}/wget-hsts";
    dataFile."less/.keep".text = "";
    dataFile."vim/undo/.keep".text = "";
    dataFile."vim/swap/.keep".text = "";
    dataFile."vim/backup/.keep".text = "";
  };

  primary-user.home-manager.home.sessionVariables = {
    RLWRAP_HOME = "$XDG_DATA_HOME/rlwrap";
    LESSHISTFILE = "$XDG_DATA_HOME/less/history";
    LESSKEY = "$XDG_DATA_HOME/less/lesskey";
    WGETRC = "$XDG_CONFIG_HOME/wgetrc";
  };
}
