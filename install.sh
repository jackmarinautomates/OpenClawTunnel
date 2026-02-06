#!/bin/bash
set -e

# Ensure we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This installer is for macOS only."
    exit 1
}

# Create download directory
DOWNLOAD_DIR=$(mktemp -d)
cd "$DOWNLOAD_DIR"

# Compile Swift script
swiftc -o OpenClawTunnel OpenClawTunnel.swift

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
</dict>
</plist>
PLIST

# Make install script executable
chmod +x "$0"

# Move to Applications folder
mv OpenClawTunnel.app /Applications/

echo "OpenClawTunnel installed successfully!"