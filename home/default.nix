{
  config,
  pkgs,
  pkgsUnstable,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/repos/space_private/dotfiles";
  # リポジトリ内のファイルを直接編集できるよう、store を経由しない symlink を張る
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.stateVersion = "25.11";

  # CLI ツール（旧 Brewfile の brew 相当）
  home.packages = with pkgs; [
    actionlint
    direnv
    fastly
    fd
    ffmpeg
    fzf
    gh
    go-task
    google-cloud-sql-proxy
    jujutsu
    lazygit
    libimobiledevice
    mise
    pkgsUnstable.neovim # 0.12 系を使うため unstable から取得
    ripgrep
    sox
    starship
    tmux
    tree-sitter
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  home.file = {
    ".zshrc".source = link ".zshrc";
    ".vimrc".source = link ".vimrc";
    ".tmux.conf".source = link "tmux/.tmux.conf";
    ".gitconfig".source = link ".gitconfig";
    ".mise.toml".source = link ".mise.toml";
    ".editorconfig".source = link ".editorconfig";

    # Claude Code
    ".claude/CLAUDE.md".source = link ".claude/CLAUDE.md";
    ".claude/settings.json".source = link ".claude/settings.json";
    ".claude/statusline-command.sh".source = link ".claude/statusline-command.sh";
    ".claude/skills".source = link ".claude/skills";
    ".claude/agents".source = link ".claude/agents";

    # Codex
    ".codex/AGENTS.md".source = link ".codex/AGENTS.md";
    ".codex/config.toml".source = link ".codex/config.toml";
    ".codex/skills".source = link ".codex/skills";

    # Agent Skills
    ".agents/skills".source = link ".agents/skills";
  };

  xdg.configFile = {
    # hosts.yml はトークンを含むため config.yml のみ管理する
    "gh/config.yml".source = link "gh/config.yml";
    "karabiner".source = link "karabiner";
    "nvim".source = link "nvim";
    "wezterm".source = link "wezterm";
    "starship.toml".source = link "starship.toml";
    "lazygit/config.yml".source = link "lazygit/config.yml";
  };
}
