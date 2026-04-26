{
  programs.tmux = {
    enable = true;
    shell = "$SHELL";
    terminal = "$TERM";
    baseIndex = 1;
    prefix = "C-a";
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    extraConfig = ''
      set -g default-command $SHELL
      set -g default-shell $SHELL

      unbind C-b
      bind-key C-a send-prefix
      set -g extended-keys on

      bind : command-prompt

      setw -g automatic-rename on

      set -g status-keys vi

      # plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'egel/tmux-gruvbox'

      # theme customization
      set -g @tmux-gruvbox 'dark'
      set -g @tmux-gruvbox-statusbar-alpha 'true'

      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
