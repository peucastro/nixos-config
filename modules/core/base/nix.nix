{inputs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      nix-path = ["nixpkgs=${inputs.nixpkgs}"];
    };

    gc = {
      automatic = true;
      dates = "monthly";
      options = "-d";
    };
  };
}
