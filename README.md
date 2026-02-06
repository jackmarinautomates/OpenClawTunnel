# OpenClawTunnel

## Prerequisites
- macOS 12.0+
- Xcode Command Line Tools
- SSH key configured for 178.156.134.97

## Quick Installation

1. Install Xcode Command Line Tools:
```bash
xcode-select --install
```

2. Generate SSH Key (if not exists):
```bash
ssh-keygen -t ed25519
```

3. Install OpenClawTunnel:
```bash
git clone https://github.com/jackmarinautomates/OpenClawTunnel
cd OpenClawTunnel
chmod +x install.sh
./install.sh
```

## Usage
1. Open from Applications folder
2. Tunnel automatically establishes to OpenClaw gateway
3. Click "Open Web UI" to access

## Troubleshooting
- Ensure SSH key is added to remote host
- Check SSH connectivity: 
  `ssh -p 4956 jack@178.156.134.97`