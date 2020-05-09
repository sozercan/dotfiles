# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sozercan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
source ~/.powerlevel10k/powerlevel10k.zsh-theme

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
alias k=kubectl
alias bu="brew update && brew upgrade && brew cleanup"
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export DOCKER_BUILDKIT=1
export DOCKER_CLI_EXPERIMENTAL=enabled

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# source /home/sozercan/.zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/linuxbrew/.linuxbrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /home/linuxbrew/.linuxbrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
