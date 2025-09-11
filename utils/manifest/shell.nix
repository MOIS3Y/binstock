{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    # build
    meson
    ninja
    # tests
    bats
  ];

  # Environment variables
  shellHook = ''
    # Exports:
    export PS1="(manifest-dev) $PS1"

    # Messages:
    echo "Manifest development shell"
    echo "Build deps: meson, ninja, bats"
  '';
}
