#!/usr/bin/env bash

set -e

# Configuration
BINARY_NAME="ai"
CONFIG_DIR="$HOME/.config/ai"
ENV_FILE="$CONFIG_DIR/.env"
INSTALL_DIR="/usr/local/bin"

# Get the directory where this setup.sh script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_BINARY="$SCRIPT_DIR/$BINARY_NAME"

echo "=== Setting up $BINARY_NAME ==="

# 1. Create config directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi

# 2. Handle .env file creation
if [ ! -f "$ENV_FILE" ]; then
    echo "Configuration file not found."
    read -rp "Enter your TOKEN: " USER_TOKEN
    
    if [ -z "$USER_TOKEN" ]; then
        echo "Error: Token cannot be empty. Aborting installation."
        exit 1
    fi

    echo "TOKEN=$USER_TOKEN" > "$ENV_FILE"
    echo "Created config file at: $ENV_FILE"
else
    echo "Config file already exists at: $ENV_FILE"
fi

# 3. Check if binary exists in the script directory
if [ ! -f "$SOURCE_BINARY" ]; then
    echo "Error: Binary '$BINARY_NAME' not found in $SCRIPT_DIR"
    echo "Please make sure '$BINARY_NAME' is in the same directory as setup.sh"
    exit 1
fi

# 4. Install binary to /usr/local/bin via sudo
echo "Installing binary to $INSTALL_DIR/$BINARY_NAME"
sudo cp "$SOURCE_BINARY" "$INSTALL_DIR/$BINARY_NAME"
sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"

echo "=== Installation complete ==="
echo "You can now run '$BINARY_NAME' from anywhere in your terminal."