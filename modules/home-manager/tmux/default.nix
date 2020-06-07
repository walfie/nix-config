{ config, pkgs, lib, ... }:
let
  # Unset some environment variables to ensure configs get reloaded. Based on:
  # https://github.com/LnL7/nix-darwin/blob/1b71f9f21c2e058292ef0d71d65d8655252f02c1/modules/programs/tmux.nix
  #
  # Background:
  # https://github.com/LnL7/nix-darwin/pull/174
  # https://github.com/rycee/home-manager/issues/183
  tmux = pkgs.runCommand pkgs.tmux.name
    { buildInputs = [ pkgs.makeWrapper ]; }
    ''
      source $stdenv/setup
      mkdir -p $out/bin
      makeWrapper ${pkgs.tmux}/bin/tmux $out/bin/tmux \
        --set __ETC_BASHRC_SOURCED "" \
        --set __ETC_ZPROFILE_SOURCED  "" \
        --set __ETC_ZSHENV_SOURCED "" \
        --set __ETC_ZSHRC_SOURCED "" \
        --set __NIX_DARWIN_SET_ENVIRONMENT_DONE "" \
        --set __HM_SESS_VARS_SOURCED ""
    '';
in
{
  primary-user.home-manager.programs.tmux = {
    enable = true;
    package = tmux;
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
