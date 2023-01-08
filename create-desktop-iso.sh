#!/bin/bash

set -e

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --iso-name)
      ISO_NAME="$2"
      shift 2
      ;;
    --username)
      USERNAME="$2"
      shift 2
      ;;
    --password)
      PASSWORD="$2"
      shift 2
      ;;
    --encryption)
      ENCRYPTION="$2"
      shift 2
      ;;
    *)
      echo "Invalid argument: $1"
      exit 1
      ;;
  esac
done

# Set default values for arguments
ISO_NAME=${ISO_NAME:-custom-fedora-desktop.iso}
USERNAME=${USERNAME:-user}
PASSWORD=${PASSWORD:-password}
ENCRYPTION=${ENCRYPTION:-luks}

# Create custom kickstart file
cat > fedora.ks <<EOF
# Kickstart file for custom Fedora installation

# Specify installation parameters
install
text
reboot

# Set root password
rootpw --iscrypted $PASSWORD

# Create user
user --name=$USERNAME --password=$PASSWORD --iscrypted

# Set up LUKS encryption
%include luks.ks

# Install desktop environment and additional packages
%packages
@^desktop
@fonts
@printing
@gnome-desktop
@web-browser
@office
@networkmanager-submodules
@system-tools
-firefox
chromium

# Reboot after installation
reboot
EOF

#