{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ./state-configuration.nix
    ./home-configuration.nix
    ../../profiles/laptop.nix
  ];

  custom.gpuChoice = "amd";
}
