# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/anhthang/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
eval "$(starship init zsh)"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir node_version vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status kubecontext root_indicator background_jobs history time)

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  autojump
  brew
  helm
  kops
  kubectl
  gitignore
  zsh-autosuggestions
  zsh-syntax-highlighting
  you-should-use
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
export NPM_BIN_PATH=$HOME/.npm/bin
export PATH=$NPM_BIN_PATH:$PATH

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function brewlist() {
    if tput setaf 1 &> /dev/null; then
        reset=$(tput sgr0);
        blue=$(tput setaf 33);
    else
        reset="\e[0m";
        blue="\e[1;34m";
    fi;
    brew leaves | while read bfile; do brew desc $bfile; echo -n "$blue     ->"; brew deps $bfile | awk '{printf(" %s ", $0)}'; echo "$reset"; done
}

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# git alias
alias main='git checkout main'
alias master='git checkout master'
alias dev='git checkout develop'
alias staging='git checkout staging'
alias merge='git merge develop'
alias commit='git commit -m'
alias reset='git reset --hard'
alias status='git status'
alias pull='git pull'
alias push='git push'
alias del='git branch -D'
alias branch='git branch'
alias add='git add .'
alias prune='git fetch --prune'
alias diff='git diff'
alias clean-merged='git branch --merged | grep -v \* | xargs git branch -D'
alias nuxt-rebuild='rm -rf node_modules; rm -rf .nuxt; rm yarn.lock; yarn'
alias npm-rebuild='rm -rf node_modules; rm package-lock.json; npm i'

# other alias
alias ktail='kubectl logs -f --tail=100'

export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
export GEM_HOME="$HOME/.gem"

#alias code='code-insiders'
