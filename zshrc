# https://raw.githubusercontent.com/punoko/dotfiles/main/.zshrc

setopt AUTO_CD
setopt CORRECT
setopt NOTIFY
setopt NO_HUP

# HISTORY
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# KEY BINDINGS
bindkey -e
bindkey '^[[F' end-of-line           # end
bindkey '^[[H' beginning-of-line     # home
bindkey '^[[Z' reverse-menu-complete # shift+tab

# EDITOR
if type nvim >/dev/null; then
  EDITOR=nvim
  VISUAL=nvim
  alias vi='nvim '
  alias vim='nvim '
fi
export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-vim}

# LS
alias ls='ls --color=auto '
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lAh'

KERNEL_NAME=$(uname -s)
function islinux() [[ $KERNEL_NAME == "Linux" ]]
function isdarwin() [[ $KERNEL_NAME == "Darwin" ]]

# MACOS
if isdarwin; then
  if ! type /opt/homebrew/bin/brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  # ANISBLE https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#running-on-macos
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
fi

# GNU UTILS ON MACOS
if isdarwin && [ -n "$HOMEBREW_PREFIX" ]; then
  PATH="$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin:$PATH"
  PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
  PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
  FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
fi

# COMPLETION
if type dircolors >/dev/null; then
  LS_COLORS=$(dircolors | awk -F\' 'NR==1 {print $2}')
fi
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt LIST_TYPES
setopt NO_LIST_BEEP
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
autoload -Uz compinit
compinit

# PROMPT
setopt PROMPT_SUBST
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%F{cyan}[%F{green}%b%F{cyan}]%f'
zstyle ':vcs_info:*' actionformats '%F{cyan}[%F{green}%b%f|%F{red}%a%F{cyan}]%f'
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info
PROMPT='%(?..%B%F{red}%?%f%b )%(!.%F{red}%n%F{yellow}.%F{green}%n%F{cyan})@%f%m %B%3~%b${vcs_info_msg_0_} %# '

# TERMINAL TITLE (OSC 0)
function precmd_title() print -nP '\e]0;%m: %~\a'
function preexec_title() print -nP '\e]0;%m: $2\a'
add-zsh-hook precmd precmd_title
add-zsh-hook preexec preexec_title

# AUTOSUGGESTIONS AND SYNTAX HIGHLIGHTING
for item in "zsh-autosuggestions" "zsh-syntax-highlighting"; do
  source "/opt/homebrew/share/${item}/${item}.zsh" 2>/dev/null ||
    source "/usr/share/zsh/plugins/${item}/${item}.zsh" 2>/dev/null ||
    echo "could not source ${item}" >&2
done

# FZF
if type fzf >/dev/null; then
  source <(fzf --zsh)
fi

# DIRENV
if type direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

# YUBIKEY
if type gpgconf >/dev/null; then
  gpgconf --launch gpg-agent
  export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
fi
if type ykman >/dev/null; then
  alias yubion='ykman config usb -e OTP'
  alias yubioff='ykman config usb -d OTP'
fi

# KUBERNETES
if type kubectl >/dev/null; then
  alias k='kubectl'
  alias kcuc='kubectl config use-context'
  alias kcgc='kubectl config get-contexts'
  source <(kubectl completion zsh)
fi

# PYTHON VENV
[ -f "$HOME/.venv/bin/activate" ] && VIRTUAL_ENV_DISABLE_PROMPT=true source "$HOME/.venv/bin/activate"

# LOCAL CONFIG
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
