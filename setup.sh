#!/bin/bash

echo "Starting Jonathans Mac setup..."

# Ensure Homebrew is in the PATH for both Intel and Apple Silicon Macs
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Intel
fi

# Install Homebrew (if not already installed)
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Re-apply path for Homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install NVM (Node Version Manager)
if ! command -v nvm &>/dev/null; then
    echo "Installing NVM..."
    # Install NVM using the official script
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    # Load NVM into the shell
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

     # Reload shell profile to ensure `nvm` is available
    source "$HOME/.bash_profile" || source "$HOME/.zshrc"
fi

# Install Node.js version 20 or 22 (example with 20)
if ! nvm ls | grep -q "v22"; then
    echo "Installing Node.js v22..."
    nvm install 22
fi

# Set Node.js version 22 as the default
nvm use 22
nvm alias default 22


# Install packages from Brewfile
brew bundle --file=Brewfile || { echo "Failed to install packages from Brewfile"; exit 1; }

# Set up dotfiles
ln -sf "$PWD/dotfiles/.zshrc" ~/.zshrc || { echo "Failed to set up .zshrc"; exit 1; }
ln -sf "$PWD/dotfiles/.gitconfig" ~/.gitconfig || { echo "Failed to set up .gitconfig"; exit 1; }

# VS Code setup
mkdir -p "$HOME/Library/Application Support/Code/User" || { echo "Failed to create VS Code directory"; exit 1; }
cp vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json" || { echo "Failed to copy VS Code settings"; exit 1; }
brew install --cask visual-studio-code
xargs -n 1 code --install-extension < vscode/extensions.txt || { echo "Failed to install VS Code extensions"; exit 1; }

echo "Setup complete!"

# Remove the project directory
cd .. || { echo "Failed to change directory"; exit 1; }
rm -rf "$(basename "$PWD")" || { echo "Failed to remove project directory"; exit 1; }