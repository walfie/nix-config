{ config, lib, pkgs, ... }:
{
  imports = [
    ./dock
    ./applescript
  ];

  # When applying macOS upgrades, `/etc/zshrc` changes that were made by the
  # nix installer tend to be removed. To avoid having to update it every time,
  # add it to user-specific zsh config. See https://github.com/NixOS/nix/issues/3616
  programs.zsh.initExtra = ''
    if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
      . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
  '';

  home.activation.setDefaults =
    lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.fileContents ./set-defaults.sh);

  home.sessionVariables = {
    BASH_SILENCE_DEPRECATION_WARNING = "1";
    HOMEBREW_NO_ANALYTICS = "1";
    CLICOLOR = "1"; # Enable colors for macOS version of `ls`
  };
}
