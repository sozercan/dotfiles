#!/bin/bash

set -xueEo pipefail

sudo apt update
sudo apt install -y build-essential curl file git
#sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

brew install zsh zsh-autosuggestions zsh-history-substring-search zsh-navigation-tools zsh-syntax-highlighting

brew install romkatv/powerlevel10k/powerlevel10k
echo 'source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme' ~/.zshrc >>!

brew install go kubernetes-cli kustomize azure-cli jq helm kind git
