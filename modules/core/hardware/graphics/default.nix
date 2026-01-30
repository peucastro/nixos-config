{lib, ...}: {
  options.custom.gpuChoice = lib.mkOption {
    type = lib.types.enum ["amd" "nvidia" "intel"];
    description = "Choose GPU setup (amd, nvidia, or intel)";
    default = "amd";
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
