echo "Starting setup..."
# ===============================
# Mac System preference overrides
# ===============================
echo "Overriding Mac System Preferences..."

# Do not open previous previewed files when opening a new one
defaults write com.apple.Preview ApplePersistenceIgnoreState YES
# Show Library
chflags nohidden ~/Library
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
# show status bar
defaults write com.apple.finder ShowstatusBar -bool true
killall Finder;

# =========
# Homebrew
# =========
echo "Installing Homebrew and GUI/Terminal apps..."

# Install homebrew
sudo chown -R $(whoami):admin /usr/local
touch ~/.zshrc

# check if homebrew exists
if [ ! -f "/opt/homebrew/bin/brew" ]; then
	echo "Installing homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$(whoami)/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"

	# So we use all of the packages we are about to install
	echo "export PATH='/usr/local/bin:$PATH'\n" >> ~/.zshrc
	source ~/.zshrc
else
	echo "Homebrew already installed. Skipping..."
fi

brew doctor
brew update

# =====================
# Install all GUI apps
# =====================
brew install --cask \
	bitwarden \
	google-chrome \
	firefox \
	brave-browser \
	iterm2 \
	visual-studio-code \
	docker \
	discord \
	vlc \
	zoom

# =====================
# Install terminal apps
# =====================
brew install \
	wget \
	git \
	nvm \
	pnpm \
	cmatrix

# ======================
# Install Fira Code font
# ======================
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# ================
# Install Oh My Zsh
# ================
# Check if oh-my-zsh is installed
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
	echo "Installing oh-my-zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	cat ~/.zshrc.pre-oh-my-zsh >> ~/.zshrc && source ~/.zshrc
	omz update

	# enable plugins
	omz plugin enable git
	omz plugin enable python
	omz plugin enable npm
	omz plugin enable nvm
	omz plugin enable docker
	omz plugin enable pip
	omz plugin enable brew

else
	echo "oh-my-zsh already installed. Skipping..."
fi

# ================
# Install Starship
# ================
# Check if starship is installed via brew
if [ ! -f "/opt/homebrew/bin/starship" ]; then
	echo "Installing starship..."
	brew install starship
	echo 'eval "$(starship init zsh)"' >> ~/.zshrc
else
	echo "starship already installed. Skipping..."
fi

# ==========
# Setup nvm
# ==========
if [ ! -d "/opt/homebrew/opt/nvm" ]; then
	echo "Setting up nvm..."
	mkdir ~/.nvm
	echo "export NVM_DIR=~/.nvm" >> ~/.zshrc
	echo "[ -s \"/opt/homebrew/opt/nvm/nvm.sh\" ] && \. \"/opt/homebrew/opt/nvm/nvm.sh\"" >> ~/.zshrc # Loads nvm
	echo "[ -s \"/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm\" ] && \. \"/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm\"" >> ~/.zshrc # Loads nvm bash_completion

	source ~/.zshrc
	nvm install --lts
	nvm use --lts
else
	echo "nvm already installed. Skipping..."
fi

# =====================
# Set up iterm2
# =====================
echo "Making iterm2 default terminal..."
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
	'<dict><key>LSHandlerContentType</key><string>public.unix-executable</string><key>LSHandlerRoleAll</key><string>com.googlecode.iterm2</string></dict>'

echo "\n====== All Done! =====\n"
echo
echo "Cheers (~Shayd3~)"


# References: https://www.robinwieruch.de/mac-setup-web-development/
