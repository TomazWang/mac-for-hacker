#!/bin/bash


# Colorize

# Set the colours you can use
black=$(tput setaf 0)
red=$(tput setaf 1)     # for warning
green=$(tput setaf 2)   
yellow=$(tput setaf 3)  # for response
blue=$(tput setaf 4)    # main stage
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
cecho "Have you read through the script you're about to run and     " "$yellow" 
cecho "understood that it will make changes to your computer? (y/N) " "$yellow" 
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
cecho "Please enter password for administrator permission:" "$yellow"
sudo -v
while true; do sudo -n; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DEFAULT_DEVICE_NAME=$(scutil --get ComputerName)
cecho "Please name this Mac: (default: ${DEFAULT_DEVICE_NAME})" "$yellow"
read -r MAC_NAME
MAC_NAME=${MAC_NAME:-$DEFAULT_DEVICE_NAME}

cecho "Set your mac's name as $MAC_NAME?(Y/n)" "$yellow"
read -r response
response=${response:-Y}
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    cecho "# Setting ComputerName to $MAC_NAME" "$cyan"
    scutil --set ComputerName "$MAC_NAME"
fi



##############################
### Homebrew ----------
##############################

# Install Homebrew
cecho "# Installing Homebrew..." "$cyan"
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew upgrade
brew update

### Creating Brewfile ----------
cecho "# Generating Brefile ..." "$cyan"
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
# cask "firefox"
# cask "firefox-nightly"
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
cecho "Please go through the Brewfile and comment out unnessary formulas and casks. " "$red"
cecho "All remaining apps will be (re-)installed.                                   " "$red"
echo ""
cecho "Open the Brewfile?(Y/n)                                                      " "$yellow"
read -r response
response=${response:-Y}
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    open "$BREW_FILE"
fi

cecho "Install Brewfile? (Y/n)" "$yello"
read -r response
response=${response:-"Y"}
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    cecho "# Installing formulas and casks via Brew..." "$cyan"
    brew bundle install -f "$BREW_FILE"
    brew cleanup
fi




####################
# Zsh
####################

cecho "# Setup Zsh..." "$cyan"

if ! test $(which zsh); then
    cecho "# Installing zsh via brew..." "$cyan"
    brew install zsh
fi

# install oh-my-zsh
cecho "# Installing oh-my-zsh..." "$cyan"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


cecho "# Logging in to Github via gh..." "$cyan"
# use public key scope for setting ssh key
gh auth login -h github.com -p HTTPS -s admin:public_key


cecho "# Setup ssh-key for git..." "$cyan"

echo "This step will create a ssh key to use will pulling repo from github"
cecho "Please enter your github account name for commenting the file and file name." "$yellow"
read -r GITHUB_ACCOUNT
GITHUB_ACCOUNT=${GITHUB_ACCOUNT:-"tomazwang"}
SSH_KEY_FILE="~/.ssh/github.$GITHUB_ACCOUNT"
PUBLIC_KEY_FILE="$SSH_KEY_FILE.pub"

echo "Generating ssh key file $SSH_KEY_FILE"
ssh-keygen -t ed25519 -C "github.com $GITHUB_ACCOUNT" -f "$SSH_KEY_FILE"
echo "Adding ssh-key to github"
gh ssh-key add "$PUBLIC_KEY_FILE" -t "$MAC_NAME"
echo "Setting ssh config"
echo "
Host github.com
  HostName github.com
  IdentityFile ${SSH_KEY_FILE="${GITHUB_ACC}"}
" >> "~/.ssh/config"



if ! test $(which chezmoi); then
  cecho "Download restore dotfiles with chezmoi?(Y/n)" "$yellow"
  read -r response
  response=${response:-"Y"}
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
  then
    cecho "# Syncing dotfiles with chezmoi..." "$blud"

    if [ ! -d $(chezmoi source-path) ]; then
      echo "Chezmoi dir not found"
      cecho "Please enter the github repo for dotfiles. (for chezmoi ex. https://github.com/username/dotfiles.git)" "$yellow"
      read -r DOTFILE_REPO

      echo "Init chezmoi from $DOTFILE_REPO"
      chezmoi init --apply "$DOTFILE_REPO"
    else
      chezmoi update
    fi
  fi


####################
# Node
####################

cecho "# Setup node env..." "$cyan"

if ! test $(which fnm); then
  echo "Install fnm to install node"
  brew install fnm
fi

fnm install --lts
fnm default lts-latest
fnm use default

node --version > ~/.npmrc

npm install -g npmrc

####################
# Java
####################

cecho "# Installing SDKman ... " "$cyan"

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"


sdk update
echo "installing java 11"
sdk install "11.0.15.9.1-amzn"
sdk use "11.0.15.9.1-amzn"

####################
# Mac App
####################

if ! test $(which mas); then
  echo "Install mas to control AppStore"
  brew install mas
fi

cecho "Log in to App Store manually to install apps with mas...." $red
cecho "Press Enter to open App Store. Please login." "$yello"
read -r NIL
open "/Applications/App Store.app"
echo "Is app store login complete.(y/n)? "
read -r response
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

########################################
# Manual setup each App
########################################

cecho "# Please setup each App manally..." "$cyan"

APPS=(
  "1Password"
  "Alfred 4"
  "Bartendar 4"
  "TickTick"
  'Todoist'
  "Itsycal"
  'Cleanshot X'
  'Magnet'
  'Yoink'
  'Surfshark'
  'Google Drive'
  'Dropbox'
  'Evernote'
  'Logseq'
  'LINE'
  'Slack'
  'Notion'
  'Spotify'
  'iTerm'
  'Postman'
  'Android Studio Preview'
  'Android Studio'
  'Visual Studio Code'
  'TablePlus'
  'Flux'
)


for app in "${APPS[@]}"
do
  APP_DIR="/Applications/${app}.app"
  echo "checking ${app}"
  if [ -d "$APP_DIR" ]; then
    echo "open $app?"
    read -r res
    res=${res:-y}
    if [[ $res =~ ^([yY][eE][sS]|[yY])$ ]]; then
      open "$APP_DIR"
    fi
  else
    echo "$app not installed"
  fi
done



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


####################
# POST ACTION
####################

echo ""
cecho "All done!" $cyan
echo ""
echo ""
cecho "################################################################################" $white
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect." $red
echo ""
echo ""
echo -n "Check for and install available OSX updates, install, and automatically restart? (y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ] ;then
    softwareupdate -i -a --restart
fi

