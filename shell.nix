{
  pkgs ? import <nixpkgs> {},
  system,
  agenix,
  ...
}:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  buildInputs = [
    pkgs.nix
    pkgs.direnv
    agenix.packages.${system}.default
    pkgs.git
    pkgs.curl
    pkgs.wget
  ];
}
