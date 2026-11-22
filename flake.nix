{
  description = " My personal NixOS & Home Manager configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default";

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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    disko,
    agenix,
    deploy-rs,
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

    hosts = {
      yoga = {
        system = "x86_64-linux";
        extraModules = [disko.nixosModules.disko];
      };
      ideapad = {
        system = "x86_64-linux";
        extraModules = [disko.nixosModules.disko];
      };
      khloe = {
        system = "x86_64-linux";
      };
      kim = {
        system = "x86_64-linux";
        extraModules = [disko.nixosModules.disko];
        deploy = {
          hostname = "192.168.1.100";
          sshUser = "homeserver";
        };
      };
    };

    overlays = {
      default = _final: prev: {
        deploy-cli = prev.callPackage ./packages/deploy/package.nix {
          deploy-rs = inputs.deploy-rs.packages.${prev.stdenv.hostPlatform.system}.default;
        };
      };
    };

    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
      };

    mkSystem = system: {
      hostname,
      user ? defaultSystemArgs.user,
      initialPassword ? defaultSystemArgs.initialPassword,
      extraModules ? [],
    }: let
      pkgs = pkgsFor system;
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs user initialPassword;
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
        pkgs = pkgsFor system;
      in {
        formatter = pkgs.alejandra;
        packages = {
          inherit (pkgs) deploy-cli;
          default = pkgs.deploy-cli;
          generate-services-table = pkgs.callPackage ./packages/generate-services-table/package.nix {
            inherit self;
          };
        };
        devShells = import ./shell.nix {
          inherit pkgs system;
          inherit (inputs) agenix deploy-rs;
        };
      }
    )
    // {
      inherit overlays;

      nixosConfigurations =
        builtins.mapAttrs (
          name: host:
            mkSystem host.system {
              hostname = name;
              extraModules = host.extraModules or [];
            }
        )
        hosts;

      deploy.nodes = builtins.mapAttrs (
        name: host: {
          inherit (host.deploy) hostname sshUser;
          remoteBuild = false;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.${host.system}.activate.nixos self.nixosConfigurations.${name};
          };
        }
      ) (nixpkgs.lib.filterAttrs (_: host: host ? deploy) hosts);

      checks =
        builtins.mapAttrs (
          system: deployLib:
            deployLib.deployChecks self.deploy
            // nixpkgs.lib.optionalAttrs (builtins.hasAttr system self.packages) {
              inherit (self.packages.${system}) deploy-cli;
            }
        )
        deploy-rs.lib;
    };
}
