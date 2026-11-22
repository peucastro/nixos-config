{lib, ...}: {
  options.custom.gpuChoice = lib.mkOption {
    type = lib.types.enum ["amd" "nvidia" "intel" "none"];
    description = "Choose GPU setup (amd, nvidia, intel, or none)";
    default = "none";
    example = "nvidia";
  };

  config = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  imports = [./amdgpu.nix ./nvidia.nix ./intel.nix];
}
