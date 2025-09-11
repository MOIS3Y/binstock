{
  description = ''
    Binstock:
      Handy utilities for modern desktop environments and workflow automation
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages = {
        manifest= import ./utils/manifest/default.nix { inherit pkgs; };
        swapshot = import ./utils/swapshot/default.nix { inherit pkgs; };
        default = self.packages.${system}.manifest;
      };
      apps = {
        manifest = {
          type = "app";
          program = "${self.packages.${system}.manifest}/bin/manifest";
          meta = self.packages.${system}.manifest.meta;
        };
        swapshot = {
          type = "app";
          program = "${self.packages.${system}.swapshot}/bin/swapshot";
          meta = self.packages.${system}.manifest.meta;
        };
        default = self.apps.${system}.manifest;
      };
      devShells = {
        manifest = import ./utils/manifest/shell.nix { inherit pkgs; };
        swapshot = import ./utils/swapshot/shell.nix { inherit pkgs; };
        default = self.devShells.${system}.manifest;
      };
    }
  );
}
