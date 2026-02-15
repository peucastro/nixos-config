{
  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "ssh";
      editor = "vim";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      pager = "less -FR";
      aliases = {
        co = "pr checkout";
      };
      browser = "zen-twilight";
    };
  };
}
