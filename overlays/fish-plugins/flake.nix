{
  description = "Overlay for fish plugins";

  inputs = {
    nix-fish.url = "github:kidonng/nix.fish";
    nix-fish.flake = false;
  };

  outputs = inputs: {
    overlays.default =
      let mkFishPlugin = name: src: { inherit name src; };
      in final: prev: {
        fishExtraPlugins = builtins.mapAttrs mkFishPlugin inputs;
      };
  };
}
