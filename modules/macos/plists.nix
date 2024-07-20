# Adapted from:
# https://github.com/AlexeyRaga/home.nix/blob/4c4e2dd8c314bca6fa08da27616a1f29d008d1af/darwin/modules/options/plists.nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.targets.darwin.plists;
in
{
  options.targets.darwin.plists = mkOption {
    description = "Edits to plists to be made via PlistBuddy";
    type = types.attrsOf types.attrs;
    default = { };
  };

  config = mkIf (pkgs.hostPlatform.isDarwin && cfg != { }) {
    home.activation.setDarwinPlists =
      let
        enquote = str: "'" + lib.strings.removeSuffix "'" (lib.strings.removePrefix "'" str) + "'";
        wrapPath = str: builtins.concatStringsSep ":" (map enquote (lib.strings.splitString ":" str));
        toValue = obj: if isBool obj then boolToString obj else toString obj;

        toCmd = file: path: value: ''
          run /usr/libexec/PlistBuddy -c "Set ${wrapPath path} ${toValue value}" $HOME/${file}
        '';
        toCmds = file: settings: concatStrings (mapAttrsToList (toCmd file) settings);
        text = concatStrings (mapAttrsToList toCmds cfg);
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] text;
  };
}
