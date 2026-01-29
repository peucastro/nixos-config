{
  users.users.homeserver = {
    isNormalUser = true;
    description = "homeserver";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9u5RuYphI3QBpNs1eVa1/X1geEllXGW5IcSb+Gf7js falecompedroac@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNjSxh7Kw2NgY8/MZ/cAgqB3rNXnmTzG/n9JcKCgrzJ"
    ];
  };

  nix.settings.trusted-users = ["root" "homeserver"];
}
