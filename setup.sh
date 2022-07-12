#!/bin/bash


# Colorize

# Set the colours you can use
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Resets the style
reset=`tput sgr0`


# Color-echo. Improved. [Thanks @joaocunha]
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}${reset}"
  return
}

echo ""
echo "###################################################"
echo "█▀▄▀█ █▀▀█ █▀▀   █▀▀▄ █▀▀█ █▀▀█ █▀▀ ▀▀█▀▀ █▀▀ █▀▀█ "
echo "█ ▀ █ █▄▄█ █──   █▀▀▄ █  █ █  █ ▀▀█   █   █▀▀ █▄▄▀ "
echo "▀   ▀ ▀  ▀ ▀▀▀   ▀▀▀  ▀▀▀▀ ▀▀▀▀ ▀▀▀   ▀   ▀▀▀ ▀  ▀ "
echo "###################################################"
echo "                    by tomazwang"
echo ""
echo ""
cecho "===================== WARNING =====================" "$red"
cecho "#     PLEASE DO NOT RUN THIS SCRIPT BLINDLY       #" "$red"
cecho "#                                                 #" "$red"
cecho "#    READ AND EDIT THIS SCRIPT BEFORE RUN THIS    #" "$red"
cecho "===================================================" "$red"


# Set continue to false by default.
CONTINUE=false

echo ""
echo "Have you read through the script you're about to run and "
echo "understood that it will make changes to your computer? (y/N)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi
unset response


if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Please go read the script, it only takes a few minutes" "$red"
  exit
fi



### START ----------

# Ask for admin password before runing
cecho "This script will ask for password..." "$blue"
sudo -v
while true; do sudo -n; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



##############################
### Homebrew ----------
##############################

# Install Homebrew
cecho "Installing Homebrew..." "$blue"
if test ! $(which brew); then
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew upgrade
brew update

### Creating Brewfile ----------
cecho "Generating Brefile ..." "$blue"
mkdir -p "~/.mac-booster"
BREW_FILE="~/.mac-booster/Brewfile"

cat > $BREW_FILE <<EOF
tap "homebrew/cask-versions"        # for beta and canary versions
tap "buo/cask-upgrade"              # upgrade all cask at once
tap "eddieantonio/eddieantonio"     # for imgcat
tap "heroku/brew"                   # for heroku
tap "jesseduffield/lazygit"          # for lazygit
tap "homebrew/cask-fonts"           # for all fonts
brew "zsh"          # zsh
brew "ack"
brew "ccat"         # colorized cat
brew "chezmoi"      # dotfile manager
brew "docker"
brew "dog"          # better dig
brew "exa"          # next-gen ls
brew "fnm"          # better nvm
brew "fzf"          # fuzzy search
brew "gh"           # github
brew "git"          # git ... duh
brew "jq"           # json query
brew "m-cli"        # cli tool to ctrl mac
brew "mas"          # Mac AppStore cli tool
brew "pidcat"       # better logcat for Android Dev
brew "scrcpy"       # Mirror Android Device
brew "pyenv"        # python env
brew "shellcheck"   # shell lint
brew "thefuck"      #
# brew "tig"        # text base git
brew "tldr"         # simpler man
brew "tmux"
brew "yank"         # select and copy part of text in cli
brew "yq"           # yml query
brew "eddieantonio/eddieantonio/imgcat"     # show image
brew "heroku/brew/heroku"                   # heroku
brew "jesseduffield/lazygit/lazygit"         # interactive git

# Dev Tools
cask "iterm2"
cask "postman"
# cask "insomnia"
cask "tableplus"
cask "visual-studio-code"

# Android Dev
cask "android-studio"
cask "android-studio-preview-canary"
# cask "flipper"
# cask "genymotion"


# Browsers
cask "firefox"
cask "firefox-nightly"
cask "google-chrome-canary"
cask "google-chrome"

# Fonts
cask "font-fira-code"


# Mac Utils
cask "alfred"           # better than spotlight
cask "bartender"        # menu cleaner
cask "disk-drill"      
cask "istat-menus"      # mac machine status
cask "itsycal"          # simple yet powerful calendar widget
cask "cleanshot"        # best screenshot app
cask "keycastr"         # show key stroke on screen

# Mac Apps
# cask "gimp"
# cask "shottr"
cask "1password"
cask "surfshark"
cask "logseq"
cask "notion"
cask "evernote"
cask "spotify"
cask "spotmenu"
cask "ticktick"
cask "todoist"
cask "vlc"
cask "slack"
cask "dropbox"
cask "google-drive"
cask "flux"
# cask "jetbrains-toolbox"
EOF


echo ""
echo "Please go through the Brewfile and comment out unnessary formulas and casks."
echo "All remaining apps will be (re-)installed."
echo ""
echo "Open the Brewfile?(Y/n)"
read -r response
response=${response:-Y}
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    open "$BREW_FILE"
fi

read -p "Install Brewfile? (Y/n)" response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    brew install -f "$BREW_FILE"
    brew cleanup
fi




####################
# Zsh
####################

cecho "Setup Zsh..." "$blue"

if ! test $(which zsh); then
    brew install zsh
fi





####################
# Node
####################






####################
# Mac App
####################

cecho "Need to log in to App Store manually to install apps with mas...." $red
echo "Opening App Store. Please login."
open "/Applications/App Store.app"
echo "Is app store login complete.(y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ]
then
    mas install 1569813296 # "1Password for Safari"
    mas install 409183694 # "Keynote"
    mas install 539883307 # "LINE"
    mas install 441258766 # "Magnet"
    mas install 425424353 # "The Unarchiver"
    mas install 457622435 # "Yoink"
else
	cecho "App Store login not complete. Skipping installing App Store Apps" $red
fi


####################
# Mac Defaults
####################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

if test ! $(which m); then
    brew install m-cli
fi

m volume 0

m dock autohide YES
m dock magnification YES
m dock prune




