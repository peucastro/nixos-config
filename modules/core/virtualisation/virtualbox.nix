{
  user,
  config,
  ...
}: {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  users.extraGroups.vboxusers.members = [user.login];
  boot.extraModulePackages = [config.boot.kernelPackages.virtualbox];
}
