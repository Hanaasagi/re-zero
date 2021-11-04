# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="debian"
#ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  vi-mode
  history-substring-search  # see https://github.com/robbyrussell/oh-my-zsh/issues/800
  zsh-autosuggestions
  zsh-syntax-highlighting
  # fast-syntax-highlighting
  kubetail
)

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd ' ' autosuggest-accept
#bindkey -M vicmd ' ' autosuggest-execute

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=magenta,bold,underline"

source $ZSH/oh-my-zsh.sh
source /root/.fzfrc

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
#

export GOPATH=/root/go
export PATH=$HOME/.cargo/bin:$GOPATH/bin:$PATH;
export FZF_DEFAULT_OPTS='--layout=reverse'
# for git utf8
export LESSCHARSET=utf-8
# gpg
export GPG_TTY=$(tty)
# krew
export PATH="${PATH}:${HOME}/.krew/bin"
# yaogurt
export VISUAL="vim"
# locale
# export LC_ALL=C
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline

# Avoid duplicates
#HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
#shopt -s histappend
# After each command, append to the history file and reread it
#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

export TERM=xterm-256color


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

alias d='dirs > ${XDG_CACHE_HOME:-~/.cache}/kuriyama/buffer && kuriyama && cd $(cat ${XDG_CACHE_HOME:-~/.cache}/kuriyama/target)'
alias fuck=proxychains
alias gc="git remote prune origin && git branch | grep -v 'master\|develop' | xargs git branch -D"
alias ls="exa --time-style=long-iso"
alias pg='pgcli -U postgres -h 127.0.0.1 -p 5432 -d'
alias less="less -r"
# k8s
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
#alias kui="docker run -it --rm -v ~/.kube/:/home/node/.kube/:ro astefanutti/kubebox"
alias kui="docker run --rm -it -v ~/.kube/config:/root/.kube/config quay.io/derailed/k9s"
alias tmux='tmux -2'

# http traffic capture
alias httpdump='httpdump(){tcpdump -nnvXS -A -i $1 -s 0 "tcp port $2 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)" };httpdump'

# auto completion
source <(kubectl completion zsh)
complete -F __start_kubectl k

eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
