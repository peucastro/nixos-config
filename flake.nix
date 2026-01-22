{
  description = " My personal NixOS & Home Manager configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    systems.url = "github:nix-systems/default";
    utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/peucastro/secrets.git";
      flake = false;
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        home-manager.follows = "home-manager";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        ndg.follows = "ndg";
      };
    };

    ndg = {
      url = "github:feel-co/ndg";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    disko,
    agenix,
    home-manager,
    nvf,
    ...
  } @ inputs: let
    defaultUser = {
      login = "peu";
      displayName = "Pedro Castro";
      email = "falecompedroac@gmail.com";
      groups = ["wheel" "dialout"];
    };

    defaultSystemArgs = {
      user = defaultUser;
      initialPassword = "nixos";
    };

    mkSystem = system: {
      hostname,
      user ? defaultSystemArgs.user,
      initialPassword ? defaultSystemArgs.initialPassword,
      extraModules ? [],
    }: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [inputs.nix-vscode-extensions.overlays.default];
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit self inputs user initialPassword;
          inherit (inputs) agenix secrets;
          host = hostname;
        };
        modules =
          [
            {nixpkgs.pkgs = pkgs;}
            ./hosts/${hostname}
          ]
          ++ extraModules;
      };
  in
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        formatter = pkgs.alejandra;
        devShells = import ./shell.nix {
          inherit pkgs system;
          inherit (inputs) agenix;
        };
      }
    )
    // {
      nixosConfigurations = {
        yoga = mkSystem "x86_64-linux" {
          hostname = "yoga";
          extraModules = [disko.nixosModules.disko];
        };
        ideapad = mkSystem "x86_64-linux" {
          hostname = "ideapad";
          extraModules = [disko.nixosModules.disko];
        };
        khloe = mkSystem "x86_64-linux" {
          hostname = "khloe";
        };
      };
    };
}
