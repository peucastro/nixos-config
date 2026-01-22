{secrets, ...}: {
  age.secrets = {
    id_ed25519 = {
      file = "${secrets}/id_ed25519.age";
      path = "/home/peu/.ssh/id_ed25519";
      symlink = true;
      mode = "0400";
      owner = "peu";
      group = "users";
    };
  };
}
