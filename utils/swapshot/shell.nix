{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    # build
    meson
    ninja
    # runtime
    grim
    slurp
    swappy
    wl-clipboard
    libnotify    
    # tests
    bats
  ];

  # Environment variables
  shellHook = ''
    # Exports:
    export PS1="(swapshot-dev) $PS1"

    # Messages:
    echo "Swapshot development shell"
    echo "Build deps: meson, ninja, bats"
    echo "Runtime deps: grim, slurp, swappy, wl-clipboard, libnotify"
  '';
}
