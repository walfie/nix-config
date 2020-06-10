{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config;
in
{
  options.dock = {
    enable = mkEnableOption "managing nix applications in the macOS dock";
    applications = mkOption {
      type = types.listOf types.path;
      default = [];
      description = ''
        List of nix applications that should appear in the macOS dock.
        Each path should have the ".app" extension.
      '';
    };
  };

  config = mkIf (pkgs.stdenv.isDarwin && cfg.dock.enable) {
    assertions = [
      (
        let
          isInvalidApp = path: !(hasPrefix "/nix" path && hasSuffix ".app" path);
          invalidApps = filter isInvalidApp cfg.dock.applications;
        in
          {
            assertion = invalidApps == [];
            message =
              # TODO: At the moment, this excludes alternate nix paths
              ''Invalid application path (should start with "/nix" and end with ".app"):''
              + concatStringsSep ", " invalidApps;
          }
      )
    ];

    primary-user.home-manager.home.activation.updateMacOsDock =
      cfg.primary-user.home-manager.lib.dag.entryAfter [ "writeBoundary" ] ''
        export PATH=${makeBinPath [ pkgs.python3 ]}:$PATH
        ${./update-dock.py} ${escapeShellArgs cfg.dock.applications}
      '';
  };
}
