{
  pkgs ? import <nixpkgs> {},
  system,
  agenix,
  deploy-rs,
  ...
}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    buildInputs = [
      pkgs.nix
      pkgs.home-manager
      pkgs.direnv
      agenix.packages.${system}.default
      deploy-rs.packages.${system}.default
      pkgs.git
      pkgs.curl
      pkgs.wget
    ];
  };
}
