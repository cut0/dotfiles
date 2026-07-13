# ====================
# 基本設定
# ====================
HISTFILE=$ZDOTDIR/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

setopt inc_append_history  # 履歴を即座に追加
setopt share_history       # 他のzshと履歴を共有
setopt AUTO_CD             # パスを直接入力してもcdする
setopt AUTO_PARAM_KEYS     # 環境変数を補完
setopt PROMPT_SUBST        # プロンプトで変数展開

# ====================
# 環境変数
# ====================
export GOPATH=$HOME/go
export BUN_INSTALL=$HOME/.bun

export GIT_EDITOR=nvim
export VISUAL=nvim
export EDITOR=nvim

# ====================
# PATH
# ====================
path=(
  /etc/profiles/per-user/$USER/bin
  /run/current-system/sw/bin
  /nix/var/nix/profiles/default/bin
  /opt/homebrew/bin
  /opt/homebrew/share/google-cloud-sdk/bin
  $GOPATH/bin
  $BUN_INSTALL/bin
  $HOME/Library/pnpm
  $HOME/.pub-cache/bin
  $HOME/.local/share/aquaproj-aqua/bin
  /Applications/WezTerm.app/Contents/MacOS
  $path
)
typeset -U path  # 重複を削除

# ====================
# 補完
# ====================
autoload -Uz compinit && compinit

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ====================
# プロンプト
# ====================
eval "$(starship init zsh)"

# ====================
# ツール・プラグイン
# ====================
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

source /etc/profiles/per-user/$USER/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /etc/profiles/per-user/$USER/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(mise activate zsh)"

export PATH="$HOME/.local/bin:$PATH"
eval "$(direnv hook zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
