{
  lib,
  config,
  ...
}: let
  categories = [
    "ADDRESS"
    "IDENTIFICATION"
    "MEASUREMENT"
    "MONETARY"
    "NAME"
    "NUMERIC"
    "PAPER"
    "TELEPHONE"
    "TIME"
  ];
in {
  options.custom.locale = lib.mkOption {
    type = lib.types.str;
    default = "pt_PT";
    description = "Locale (language_COUNTRY) used for the LC_* settings.";
  };

  config = {
    i18n.extraLocaleSettings = lib.genAttrs categories (_: "${config.custom.locale}.UTF-8");
    time.timeZone = lib.mkDefault "Europe/Lisbon";
  };
}
