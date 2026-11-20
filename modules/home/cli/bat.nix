{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "gruvbox-dark";
    };
    extraPackages = [
      pkgs.bat-extras.batman
      pkgs.bat-extras.batpipe
      pkgs.bat-extras.batdiff
    ];
  };
}
