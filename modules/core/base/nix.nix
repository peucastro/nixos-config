{inputs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "monthly";
      options = "-d";
    };

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
