{ username, ... }:
{
  # Determinate Nix が nix daemon を管理するため、nix-darwin 側の管理は無効化する
  nix.enable = false;

  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;

  # zsh-syntax-highlighting を /etc/profiles/per-user 配下にリンクさせる
  environment.pathsToLink = [ "/share/zsh-syntax-highlighting" ];

  # GUI アプリとフォントは Homebrew cask で管理（darwin-rebuild 時に同期される）
  # 対象外: MDM 配布物（Cisco / Falcon / FortiClient / Cloudflare WARP / Self Service+ / zoom）、
  # cask 未収録の手動インストール品（CuaDriver / Pencil / Raycast Beta / WinTicket TV Viewer / Python 3.13）
  # ※ zoom は cask の pkg インストーラが既存インストールと衝突して失敗するため対象外
  homebrew = {
    enable = true;
    brews = [
      "libpq" # psql 等のクライアント一式（.zshrc が /opt/homebrew/opt/libpq/bin を参照）
      "mas" # masApps の管理に必要
      "rulesync" # nixpkgs 未収録
    ];
    casks = [
      "1password"
      "android-studio"
      "arc"
      "chatgpt"
      "claude"
      "cleanshot"
      "codex"
      "cursor"
      "discord"
      "docker-desktop"
      "figma"
      "font-caskaydia-cove-nerd-font"
      "font-hackgen-nerd"
      "gcloud-cli"
      "google-chrome"
      "google-japanese-ime"
      "karabiner-elements"
      "keepassxc"
      "notchi"
      "obsidian"
      "raycast"
      "spotify"
      "visual-studio-code"
      "wezterm"
    ];
    masApps = {
      "Developer" = 640199958;
      "GarageBand" = 682658836;
      "iMovie" = 408981434;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Prime Video" = 545519333;
      "Slack" = 803453959;
      "Xcode" = 497799835;
    };
  };

  system.stateVersion = 6;
}
