{ pkgs ? import <nixpkgs> {} }: 

let
  inherit (pkgs)
    lib;
in

pkgs.stdenv.mkDerivation {
  pname = "manifest";
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

  meta = with lib; {
    description = ''
      A utility for displaying information about the binstock utilities repository
    '';
    homepage = "https://github.com/MOIS3Y/utils/manifest";
    license = licenses.mit;
    maintainers = [ maintainers.MOIS3Y ];
    platforms = platforms.linux;
  };
}
