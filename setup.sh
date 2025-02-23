#!/bin/bash

echo "Starting Jonathans Mac setup..."

# Ensure Homebrew is in the PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"s

# Install Homebrew (if not already installed)
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install packages from Brewfile
brew bundle --file=Brewfile || { echo "Failed to install packages from Brewfile"; exit 1; }

# Set up dotfiles
ln -sf "$PWD/dotfiles/.zshrc" ~/.zshrc || { echo "Failed to set up .zshrc"; exit 1; }
ln -sf "$PWD/dotfiles/.gitconfig" ~/.gitconfig || { echo "Failed to set up .gitconfig"; exit 1; }

# VS Code setup
mkdir -p "$HOME/Library/Application Support/Code/User" || { echo "Failed to create VS Code directory"; exit 1; }
cp vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json" || { echo "Failed to copy VS Code settings"; exit 1; }
xargs -n 1 code --install-extension < vscode/extensions.txt || { echo "Failed to install VS Code extensions"; exit 1; }

echo "Setup complete!"

# Remove the project directory
cd .. || { echo "Failed to change directory"; exit 1; }
rm -rf "$(basename "$PWD")" || { echo "Failed to remove project directory"; exit 1; }