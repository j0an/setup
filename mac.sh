#!/usr/bin/env bash

if [[ ! -d "$HOME/.bin/" ]]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch $HOME/.zshrc
fi

// Create working directory
if [[ ! -d "$HOME/Sites/" ]]; then
  mkdir "$HOME/Sites"
fi

println() {
  printf "%b\n" "$1"
}

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      brew upgrade "$@"
      println "Upgraded $1"
    else
      println "$1 already installed"
    fi
  else
    brew install "$@"
  fi
}

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

brew_is_installed() {
  local NAME=$(brew_expand_alias "$1")

  brew list -1 | grep -Fqx "$NAME"
}

brew_is_upgradable() {
  local NAME=$(brew_expand_alias "$1")

  local INSTALLED=$(brew ls --versions "$NAME" | awk '{print $NF}')
  local LATEST=$(brew info "$NAME" 2>/dev/null | head -1 | awk '{gsub(/,/, ""); print $3}')

  [ "$INSTALLED" != "$LATEST" ]
}

if ! command -v brew &>/dev/null; then
  println "The missing package manager for OS X"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  if ! grep -qs "recommended by brew doctor" ~/.bashrc; then
    println "Put Homebrew location earlier in PATH..."
      printf '\n# recommended by brew doctor\n' >> ~/.bashrc
      printf 'export PATH="/usr/local/bin:$PATH"\n' >> ~/.bashrc
      export PATH="/usr/local/bin:$PATH"
  fi
else
  println "Homebrew already installed. Skipping..."
fi

println "Updating Homebrew formulas..."
brew update

println "Installing Brew Cask..."
  brew tap caskroom/cask
  brew_install_or_upgrade 'caskroom/cask/brew-cask'
  brew upgrade brew-cask

println "Installing iTerm2..."
  brew cask install iterm2

println "Installing PhantomJS..."
  brew_install_or_upgrade 'phantomjs'

println "Installing MySQL 5.6..."
  brew tap homebrew/versions
  brew_install_or_upgrade 'homebrew/versions/mysql56'

println "Installing QT, used by Capybara Webkit for integration testing..."
  brew_install_or_upgrade 'qt'

println "Installing ChromeDriver, to drive Chrome via Selenium..."
  brew_install_or_upgrade 'chromedriver'

println "Installing Git..."
  brew_install_or_upgrade 'git'

println "Installing SourceTree..."
  brew_install_or_upgrade 'sourcetree'

println "Installing Firefox..."
  brew cask install firefox

println "Installing Chrome..."
  brew cask install google-chrome

println "Installing Atom..."
  brew cask install atom

println "Installing Atom Packages"
  apm install file-type-icons
  apm install atom-beautify
  apm install auto-detect-indentation
  apm install auto-update-packages
  apm install pigments
  apm install linter
  apm install emmet
  apm install merge-conflicts
  apm install highlight-selected
  apm install autoclose-html
  apm install linter-csslint
  apm install linter-htmlhint
  apm install linter-jshint
  apm install linter-rubocop
  apm install linter-ruby
  apm install linter-slim
  apm install minimap
  apm install rails-rspec
  apm install ruby-block
  apm install ruby-slim
  apm install jshint
  apm install autocomplete-paths
  apm install autocomplete-plus
  apm install autocomplete-ruby
  apm install color-picker
  apm install dockblockr
  apm install editorconfig
  apm install sublime-style-column-selection
  apm install language-haml
  apm install language-blade

println "Installing Slack..."
  brew cask install slack

println "Installing Spotify..."
  brew cask install spotify

println "Installing Skype..."
  brew cask install skype

println "Installing Telegram..."
  brew cask install telegram

println "Installing Dropbox..."
  brew cask install dropbox

println "Installing Flux..."
  brew cask install flux

println "Installing SizeUp..."
  brew cask install sizeup

println "Installing Transmit..."
  brew cask install transmit

println "Installing AppCleaner..."
  brew cask install appcleaner

println "Installing Transmission..."
  brew cask install transmission

println "Installing Sketch..."
  brew cask install sketch

println "Installing Adobe Photoshop..."
  brew cask install adobe-photoshop-cc

println "Installing VLC..."
  brew cask install vlc


node_version="v4.6.0"

println "Installing NVM, Node.js, and NPM, for running apps and installing JavaScript packages..."
  brew_install_or_upgrade 'nvm'

  if ! grep -qs 'source $(brew --prefix nvm)/nvm.sh' ~/.zshrc; then
    printf 'export PATH="$PATH:/usr/local/lib/node_modules"\n' >> ~/.zshrc
    printf 'source $(brew --prefix nvm)/nvm.sh\n' >> ~/.zshrc
  fi

  source $(brew --prefix nvm)/nvm.sh
  nvm install "$node_version"

  println "Setting $node_version as the global default nodejs..."
  nvm alias default "$node_version"

if ! command -v rvm &>/dev/null; then

  println "Installing rvm, to change Ruby versions..."
  curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles
  source ~/.rvm/scripts/rvm

else

  println "Rvm already installed. Skipping..."
fi

println "Upgrading and linking OpenSSL..."
  brew_install_or_upgrade 'openssl'
  brew unlink openssl && brew link openssl --force

ruby_version="2.3.1"

println "Installing Ruby $ruby_version..."
  rvm install "$ruby_version"
  rvm use "$ruby_version" --default

println "Updating to latest Rubygems version..."
  gem update --system

println "Configuring Bundler for faster, parallel gem installation..."
  number_of_cores=$(sysctl -n hw.ncpu)
  bundle config --global jobs $((number_of_cores - 1))


println "Cleanup..."
  brew cleanup
  brew cask cleanup


println "Loading OSX Config file..."

if [ -f "$HOME/osx-config.sh" ]; then
  . "$HOME/osx-config.sh"
fi
