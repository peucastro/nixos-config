{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ./state-configuration.nix
    ./home-configuration.nix
    ../../secrets
    ../../profiles/laptop.nix
  ];

  custom.gpuChoice = "amd";
}
