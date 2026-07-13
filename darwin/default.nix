{ username, ... }:
{
  # Determinate Nix が nix daemon を管理するため、nix-darwin 側の管理は無効化する
  nix.enable = false;

  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;

  # zsh-syntax-highlighting を /etc/profiles/per-user 配下にリンクさせる
  environment.pathsToLink = [ "/share/zsh-syntax-highlighting" ];

  # GUI アプリとフォントは Homebrew cask で管理（darwin-rebuild 時に同期される）
  homebrew = {
    enable = true;
    brews = [
      "libpq" # psql 等のクライアント一式（.zshrc が /opt/homebrew/opt/libpq/bin を参照）
      "rulesync" # nixpkgs 未収録
    ];
    casks = [
      "codex"
      "font-caskaydia-cove-nerd-font"
      "font-hackgen-nerd"
      "gcloud-cli"
      "wezterm"
    ];
  };

  system.stateVersion = 6;
}
