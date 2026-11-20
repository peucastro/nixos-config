{
  pkgs,
  user,
  ...
}: {
  users.users.${user.login}.packages = [
    pkgs.deploy-cli
  ];
}
