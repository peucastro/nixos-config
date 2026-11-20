{
  pkgs,
  user,
  self,
  ...
}: {
  users.users.${user.login}.packages = [
    self.packages.${pkgs.stdenv.hostPlatform.system}.deploy-cli
  ];
}
