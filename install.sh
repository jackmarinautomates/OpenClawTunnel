#!/bin/bash
set -e

# Ensure we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This installer is for macOS only."
    exit 1
fi

# Check for Xcode Command Line Tools
if ! command -v xcode-select &> /dev/null; then
    echo "Xcode Command Line Tools are required. Please install them first."
    echo "Run: xcode-select --install"
    exit 1
fi

# Check for existing SSH key
SSH_KEY_PATH=~/.ssh/id_ed25519
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "No SSH key found at $SSH_KEY_PATH"
    echo "Please generate an SSH key first:"
    echo "ssh-keygen -t ed25519 -f $SSH_KEY_PATH"
    exit 1
fi

# Create download directory
DOWNLOAD_DIR=$(mktemp -d)
cd "$DOWNLOAD_DIR"

# Download Swift script
curl -sSL https://raw.githubusercontent.com/jackmarinautomates/OpenClawTunnel/main/OpenClawTunnel.swift -o OpenClawTunnel.swift

# Compile Swift script with error handling
if ! swiftc -parse-as-library -o OpenClawTunnel OpenClawTunnel.swift; then
    echo "Swift compilation failed. Ensure Xcode Command Line Tools are installed."
    exit 1
fi

# Create app bundle structure
mkdir -p OpenClawTunnel.app/Contents/MacOS
mv OpenClawTunnel OpenClawTunnel.app/Contents/MacOS/

# Create Info.plist
mkdir -p OpenClawTunnel.app/Contents
cat > OpenClawTunnel.app/Contents/Info.plist << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>OpenClawTunnel</string>
    <key>CFBundleIdentifier</key>
    <string>com.openclaw.tunnel</string>
    <key>CFBundleName</key>
    <string>OpenClawTunnel</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

# Move to Applications folder
mv OpenClawTunnel.app /Applications/

echo "OpenClawTunnel installed successfully!"
echo "Open from Applications folder or run: open /Applications/OpenClawTunnel.app"