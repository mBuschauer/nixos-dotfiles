# Check if the script is run with sudo or as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root or with sudo." 
  exit 1
fi

sudo cp -r ./home /etc/nixos/
sudo cp -r ./modules /etc/nixos/
sudo cp ./configuration.nix /etc/nixos
sudo cp ./flake.nix /etc/nixos
