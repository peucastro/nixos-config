{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.alsa-utils
  ];
}
