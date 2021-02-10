export ZSH=/root/.oh-my-zsh

ZSH_THEME="sagiri"

plugins=(
  git
  vi-mode
  history-substring-search  # see https://github.com/robbyrussell/oh-my-zsh/issues/800
  zsh-autosuggestions
  zsh-syntax-highlighting
)

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd ' ' autosuggest-accept
#bindkey -M vicmd ' ' autosuggest-execute

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=magenta,bold,underline"
HIST_STAMPS="yyyy-mm-dd"


source $ZSH/oh-my-zsh.sh

# cusotm tmux
alias tmux="tmux -2"


# yaogurt
export VISUAL="vim"
export GPG_TTY=$(tty)


