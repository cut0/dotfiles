{
  description = "cut0 dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    # 一部パッケージ（neovim 等）を新しいバージョンで使うための unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
    }:
    let
      # アカウント名をリポジトリに含めないため環境変数から取得する（--impure が必要）
      username =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          user = if sudoUser != "" then sudoUser else builtins.getEnv "USER";
        in
        if user != "" then user else throw "ユーザー名を取得できません。--impure を付けて実行してください";
    in
    {
      # ホスト名に依存しない名前にしているため、--flake .#mac と明示指定して使う
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit username; };
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              pkgsUnstable = import nixpkgs-unstable { system = "aarch64-darwin"; };
            };
            home-manager.backupFileExtension = "before-home-manager";
            home-manager.users.${username} = import ./home;
          }
        ];
      };
    };
}
