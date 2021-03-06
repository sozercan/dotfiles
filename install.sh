#!/usr/bin/env zsh

echo "\e[31m\n\n!! WARNING: This script will overwrite existing ZSH, Bash Profile and Oh-My-ZSH configurations !! \n"
echo "!! WARNING: Please do not open other terminal session until the scripts finishes !! \e[39m\n"

case "$(uname -s)" in
    Darwin)
        echo "\e[32m[DOT]\e[33m Darwin based environment detected ... \e[39m\n"
    ;;
    Linux)
        if [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
            echo "\e[32m[DOT]\e[33m Debian based environment detected ... \e[39m\n"
            # install required dependencies
            echo "\e[32m[DOT]\e[34m installing packages ... \e[39m\n"
            sudo apt -y install build-essential git debconf locales > /dev/null 2>&1
            # generate utf-8 environment
            echo "\e[32m[DOT]\e[34m generating locales ... \e[39m\n"
            sudo locale-gen --purge en_US.UTF-8 > /dev/null 2>&1
        # check if environment is fedora/redhat
        elif [ "$(grep -Ei 'fedora|redhat|centos' /etc/*release)" ]; then
            echo "\e[32m[DOT]\e[33m RedHat based environment detected ... \e[39m\n"
            # install required dependencies
            echo "\e[32m[DOT]\e[34m installing packages ... \e[39m\n"
            sudo dnf install @development-tools git -y > /dev/null 2>&1
            # generate utf-8 environment
            echo "\e[32m[DOT]\e[34m generating locales ... \e[39m\n"
            localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 > /dev/null 2>&1
        fi
    ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        echo "\e[32m[DOT]\e[33m Windows based environment detected ... \e[39m\n"
        echo "\e[32m[DOT]\e[31m This is not a supported environment. Exiting. \e[39m\n"
        exit 1
     ;;
    *)
        echo "\e[32m[DOT]\e[31m Unable to detected the environment! \e[39m\n"
        echo "\e[32m[DOT]\e[31m This is not a supported environment. Exiting. \e[39m\n"
        exit 1
    ;;
esac

# exports the language definitions
echo "\e[32m[DOT]\e[34m exporting locales ... \e[39m\n"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# tells homebrew to do a silent install
export CI=1

# delete previous installations
echo "\e[32m[DOT]\e[34m deleting previous installation of this dotfiles ... \e[39m\n"
rm -rf ~/.oh-my-zsh/ ~/.zshrc ~/.bash_profile ~/.p10k.zsh > /dev/null 2>&1

# copies base bash profile
echo "\e[32m[DOT]\e[34m copying bash profile file ... \e[39m\n"
cp -rf .bash_profile ~/.bash_profile > /dev/null 2>&1

# install the homebrew (if stdin is available requires confirmation)
echo "\e[32m[DOT]\e[34m installing homebrew ...  \e[39m\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

case "$(uname -s)" in
    Darwin)
        echo "\e[32m[DOT]\e[34m installing nerd fonts ... \e[39m\n"
        brew tap homebrew/cask-fonts > /dev/null 2>&1

        brew install font-hack-nerd-font > /dev/null 2>&1
    ;;
    Linux)
        echo "\e[32m[DOT]\e[34m configuring homebrew ... \e[39m\n"

        # installs homebrew on the environment
        test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
        test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
        echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

        echo "\e[32m[DOT]\e[34m installing nerd fonts ... \e[39m\n"
        # creates local fonts directory
        mkdir -p ~/.local/share/fonts

        (
            # goes to the directory
            cd ~/.local/share/fonts

            # downloads the font file
            curl -fLo "Hack NF.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf > /dev/null 2>&1

            # reloads font cache
            echo "\e[32m[DOT]\e[34m rebuilding fonts ... \e[39m\n"
            fc-cache -f -v > /dev/null 2>&1
        )
    ;;
    *)
    ;;
esac

echo "\e[32m[DOT]\e[34m installing homebrew packages ... \e[39m\n"

# installs all the required packages
brew install go kubernetes-cli kustomize jq helm kind git git-lfs gh wget > /dev/null 2>&1

# configures git lfs
echo "\e[32m[DOT]\e[34m configuring git lfs ... \e[39m\n"
git lfs install --system > /dev/null 2>&1

# updates git configuration
echo "\e[32m[DOT]\e[34m enabling default git strategies ... \e[39m\n"
git config --global pull.rebase true

# installs oh-my-zsh
echo "\e[32m[DOT]\e[34m installing oh my zsh ... \e[39m\n"
! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1

echo "\e[32m[DOT]\e[34m installing oh my zsh plugins ... \e[39m\n"

# installs power-level-10k
! git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" > /dev/null 2>&1

# installs zsh auto suggestions
! git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" > /dev/null 2>&1

# installs zsh-syntax-highlighting
! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" > /dev/null 2>&1

echo "\e[32m[DOT]\e[34m copying environment files ... \e[39m\n"

# copies the ZSH environment file
cp -rf .zshrc ~/.zshrc > /dev/null 2>&1

# copies the PowerLevel10K configuration file
cp -rf .p10k.zsh ~/.p10k.zsh > /dev/null 2>&1

# loads the source
source ~/.zshrc

echo "\e[32mInstallation Finished. Exiting. \e[39m\n"

exit 0