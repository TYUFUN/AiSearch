#!/usr/bin/env bash

set -e

# Configuration
BINARY_NAME="ai"
CONFIG_DIR="$HOME/.config/ai"
ENV_FILE="$CONFIG_DIR/.env"
INSTALL_DIR="/usr/local/bin"
TARGET_BINARY="$INSTALL_DIR/$BINARY_NAME"

# GitHub Releases URL for the latest version
DOWNLOAD_URL="https://github.com/TYUFUN/AiSearch/releases/latest/download/$BINARY_NAME"

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

# 3. Check if binary is already installed and handle update
SHOULD_DOWNLOAD=true
if [ -f "$TARGET_BINARY" ]; then
    echo "Binary '$BINARY_NAME' is already installed at $TARGET_BINARY."
    read -rp "Do you want to download and update to the latest version? (y/N): " UPDATE_CHOICE
    if [[ ! "$UPDATE_CHOICE" =~ ^[Yy]$ ]]; then
        echo "Skipping update."
        SHOULD_DOWNLOAD=false
    fi
fi

# 4. Download and install binary if needed
if [ "$SHOULD_DOWNLOAD" = true ]; then
    echo "Downloading latest $BINARY_NAME from GitHub Releases..."
    TEMP_FILE="/tmp/$BINARY_NAME"
    
    # Download via curl (-L for redirects, -s for silent mode, --fail to exit on 404)
    if ! curl -sL --fail "$DOWNLOAD_URL" -o "$TEMP_FILE"; then
        echo "Error: Failed to download binary from GitHub Releases."
        echo "Make sure you have created a Release and attached a file named '$BINARY_NAME'."
        exit 1
    fi

    if [ ! -s "$TEMP_FILE" ]; then
        echo "Error: Downloaded file is empty."
        exit 1
    fi

    echo "Installing binary to $INSTALL_DIR/$BINARY_NAME"
    sudo mv "$TEMP_FILE" "$TARGET_BINARY"
    sudo chmod +x "$TARGET_BINARY"
    echo "Binary installed/updated successfully!"
fi

echo "=== Installation complete ==="
echo "You can now run '$BINARY_NAME' from anywhere in your terminal."