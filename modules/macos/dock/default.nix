{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config;
in
{
  options.macos-dock = {
    enable = mkEnableOption "managing nix applications in the macOS dock";
    applications = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        List of nix applications that should appear in the macOS dock.
        Each path should have the ".app" extension.
      '';
    };
  };

  config = mkIf (pkgs.stdenv.isDarwin && cfg.macos-dock.enable) {
    assertions = [
      (
        let
          isInvalidApp = path: !(hasPrefix "/nix" path && hasSuffix ".app" path);
          invalidApps = filter isInvalidApp cfg.macos-dock.applications;
        in
        {
          assertion = invalidApps == [ ];
          message =
            ''Invalid application path (should start with "/nix" and end with ".app"):''
            + concatStringsSep ", " invalidApps;
        }
      )
    ];

    home.activation.updateMacOsDock =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH=${makeBinPath [ pkgs.python3 ]}:$PATH
        ${./update-dock.py} ${escapeShellArgs cfg.macos-dock.applications}
      '';
  };
}
