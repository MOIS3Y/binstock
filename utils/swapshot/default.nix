{ pkgs ? import <nixpkgs> {} }: 

let
  inherit (pkgs)
    lib;
in

pkgs.stdenv.mkDerivation {
  pname = "swapshot";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.bats
  ];

  mesonFlags = [
    "-Dbash-completions=true"
    "-Dzsh-completions=true"
  ];

  buildInputs = [
    pkgs.grim
    pkgs.slurp
    pkgs.swappy
    pkgs.wl-clipboard
    pkgs.libnotify
  ];

  meta = with lib; {
    description = "Capture and edit screen regions effortlessly";
    homepage = "https://github.com/MOIS3Y/utils/swapshot";
    license = licenses.mit;
    maintainers = [ maintainers.MOIS3Y ];
    platforms = platforms.linux;
  };
}
