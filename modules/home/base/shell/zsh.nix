{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "fzf"
        "gh"
        "git"
        "man"
        "sudo"
        "tldr"
        "z"
      ];
    };
    shellAliases = {
      zshconfig = "vim ~/.zshrc";
      ohmyzsh = "vim ~/.oh-my-zsh";
      dotconfig = "cd ~/nixos-config && code ~/nixos-config";
    };
  };
}
