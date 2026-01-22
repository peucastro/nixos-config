{
  description = "My personal homeserver declarative configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/peucastro/secrets.git";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    agenix,
    secrets,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    inherit (nixpkgs) lib;
  in {
    devShells.${system}.default = import ./shell.nix {inherit system pkgs agenix;};

    formatter.${system} = pkgs.alejandra;

    nixosConfigurations.khloe = lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit lib agenix secrets;
      };
      modules = [
        ./hosts/khloe/default.nix
      ];
    };
  };
}
