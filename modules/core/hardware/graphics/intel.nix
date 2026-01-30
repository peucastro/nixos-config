{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (config.custom.gpuChoice == "intel") {
  boot.initrd.kernelModules = ["i915"];

  hardware.graphics.extraPackages = [
    pkgs.intel-media-driver
    pkgs.intel-compute-runtime
    pkgs.vpl-gpu-rt
  ];

  environment.systemPackages = [
    pkgs.vulkan-tools
    pkgs.libva-utils
    pkgs.intel-gpu-tools
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
