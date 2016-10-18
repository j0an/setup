# Setup

Script to install base environment for Ruby development.

## Install on Mac OS X

```
curl -L https://raw.githubusercontent.com/j0an/setup/master/mac.sh | bash
```

## Installed libraries

The script will install:

* homebrew
* oh-my-zsh
* mysql
* rvm
* ruby-2.3.1
* nvm
* qt
* chromedriver
* spotify
* slack
* firefox
* atom (with some packages)
* flux
* dropbox
* skype
* sketch
* adobe photoshop cc
* vlc
* transmit
* transmission
* app cleaner

# FAQ

## I get a permissions error. Why?

You may need to update your local libraries directory.

```
sudo chown -R $(whoami):admin /Library/Caches/Homebrew
sudo chown -R $(whoami):admin /opt/homebrew-cask/
sudo chown -R $(whoami):admin /usr/local/
```

## I get failure errors. Why?

You have to install Xcode developer tools

```
xcode-select --install
```

## But I don't want \<application> installed.

Just remove \<application> from https://github.com/ombulabs/setup/blob/master/mac.sh


## Contributions

Please fork this repository and send a pull request with the changes. Thanks!
