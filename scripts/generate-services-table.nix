with builtins.getFlake (toString ../.); let
  lib = import <nixpkgs/lib>;
  hostname = "khloe";
  hs = nixosConfigurations.${hostname}.config.homeserver;
  enabledHomepageServices =
    builtins.filter
    (x: hs.services.${x}.enable or false && (hs.services.${x} ? homepage))
    (builtins.filter (x: x != "enable") (builtins.attrNames hs.services));

  servicesByCategory =
    lib.lists.groupBy (
      x: hs.services.${x}.homepage.category
    )
    enabledHomepageServices;

  categories = builtins.attrNames servicesByCategory;

  homepageServiceRow = service: let
    serviceConfig = hs.services.${service}.homepage;
    inherit (serviceConfig) icon;
    iconExt = lib.lists.last (lib.strings.splitString "." icon);
    iconCdnPath =
      if iconExt == "svg"
      then "svg"
      else "png";
    iconlink = "<img src='https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/${iconCdnPath}/${icon}' width=32 height=32>";
  in "|${iconlink}|${serviceConfig.name}|${serviceConfig.description}|";

  tables =
    builtins.map (
      cat: let
        services = servicesByCategory.${cat} or [];
        rows = builtins.map homepageServiceRow services;
      in
        if services == []
        then ""
        else lib.strings.concatLines (["### ${cat}" "|Icon|Name|Description|" "|---|---|---|"] ++ rows)
    )
    categories;
in
  lib.strings.concatLines (builtins.filter (x: x != "") tables)
