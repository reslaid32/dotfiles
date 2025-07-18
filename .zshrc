# ~/.zshrc

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set Starship prompt (install: `curl -sS https://starship.rs/install.sh | sh`)
# Alternative: Use Powerlevel10k by setting ZSH_THEME="powerlevel10k/powerlevel10k"
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if [ ! -f "$ZSH/oh-my-zsh.sh" ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
fi

# Source Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Plugins
plugins=(
  git                 # Git aliases and completions
  zsh-autosuggestions # Suggests commands as you type
  zsh-syntax-highlighting # Syntax highlighting for commands
  zsh-history-substring-search # Up/down arrow history search
  fzf                 # Fuzzy finder integration
  docker              # Docker completions
  kubectl             # Kubernetes completions
  take                # take 0 = (mkdir 0 && cd 0)
)

# Environment variables
export EDITOR='nvim'  # Default editor
export VISUAL='nvim'
export PATH="$HOME/.local/bin:$PATH"  # Add user bin directory
# Preferred fetch tool (can be overridden in ~/.zsh_custom)
export FETCH="fastfetch"

# OS-specific settings
case "$OSTYPE" in
  darwin*)
    # macOS-specific paths (e.g., Homebrew)
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
    ;;
  linux*)
    # Linux-specific settings
    export PATH="/usr/local/bin:$PATH"
    ;;
esac

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS  # Ignore duplicate commands
setopt HIST_IGNORE_SPACE     # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS    # Remove extra blanks from history
setopt SHARE_HISTORY         # Share history across sessions

# Completion settings
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' menu select                   # Interactive completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colorful completions

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^R' history-incremental-search-backward     # Ctrl+R for history search
bindkey '^T' fzf-file-widget                         # Ctrl+T for fzf file search
bindkey '^Y' fzf-history-widget                      # Ctrl+Y for fzf history search

# Aliases
alias ls='ls --color=auto'  # Colorized ls
alias ll='ls -lah'          # Long listing with human-readable sizes
alias la='ls -A'            # List all files, including hidden
alias gs='git status'       # Git status
alias gd='git diff'         # Git diff
alias gc='git commit'       # Git commit
alias gp='git push'         # Git push
alias ga='git add'          # Git add

# Kubernetes completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Docker completion
[[ $commands[docker] ]] && source <(docker completion zsh)

# fzf configuration
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Custom functions
# Quick cd to git root
cdg() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$root" ]]; then
    cd "$root"
  else
    echo "not a git repository"
  fi
}

# Source custom scripts or local overrides
[ -f ~/.zsh_custom ] && source ~/.zsh_custom

# Initialize direnv (if installed)
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

if [[ -n "$FETCH" ]]; then
  fetch_cmd="${FETCH%% *}"
  if command -v "$fetch_cmd" >/dev/null 2>&1; then
    eval "$FETCH"
  fi
fi
