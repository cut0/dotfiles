{ username, ... }:
{
  # Determinate Nix が nix daemon を管理するため、nix-darwin 側の管理は無効化する
  nix.enable = false;

  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;

  system.stateVersion = 6;
}
