{ pkgs, lib, ... }:
let
  # Run AppleScript that switches the current Chrome tab to the first
  # YouTube/Twitch tab, and focuses on the text input field
  #
  # In Chrome: View -> Developer -> Allow JavaScript from Apple Events
  focus-chat = pkgs.writeShellScriptBin "focus-chat" ''
    osascript -l JavaScript -e ${lib.escapeShellArg (lib.fileContents ./focus-chat.js)}
  '';

  toggle-emote-picker = pkgs.writeShellScriptBin "toggle-emote-picker" ''
    osascript -l JavaScript -e ${lib.escapeShellArg (lib.fileContents ./toggle-emote-picker.js)}
  '';
in
{
  home.packages = [
    focus-chat
    toggle-emote-picker
  ];
}

