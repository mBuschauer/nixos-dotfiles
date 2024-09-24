# Check if the script is run with sudo or as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root or with sudo."
  echo "Attempting to elevate privileges..."
  exec sudo "$0" "$@"
  exit 1
fi

# Function to safely move files to the trash if they exist and are not excluded
safe_trash() {
  local filepath=$1
  local filename=$(basename "$filepath")

  # Exclude specific files
  if [[ "$filename" == "hardware-configuration.nix" || "$filename" == "flake.lock" ]]; then
    return
  fi

  # If the file or directory exists, move it to the trash
  if [ -e "$filepath" ]; then
    sudo trash "$filepath" >/dev/null 2>&1
  fi
}

# Move files to the trash, with checks
safe_trash "/etc/nixos/home"
safe_trash "/etc/nixos/modules"
safe_trash "/etc/nixos/configuration.nix"
safe_trash "/etc/nixos/flake.nix"
safe_trash "/etc/nixos/settings.nix"
safe_trash "/etc/nixos/secrets.nix"

echo "Removed old configuration"

# Copy the new files and directories
sudo cp -r ./home /etc/nixos/
sudo cp -r ./modules /etc/nixos/
sudo cp ./configuration.nix /etc/nixos
sudo cp ./flake.nix /etc/nixos
sudo cp ./settings.nix /etc/nixos
sudo cp ./secrets.nix /etc/nixos

echo "Successfully pushed new configuration"

# Change ownership of the files
sudo chown -R 1000:100 /etc/nixos