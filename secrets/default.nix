{agenix, ...}: {
  imports = [agenix.nixosModules.default];

  age = {
    identityPaths = [
      "/etc/ssh/agenix_shared_key"
      "/etc/ssh/agenix_recovery_key"
    ];
  };
}
