{ ... }:
{
	imports = 
	[
		# folders
		./admin
		./desktopEnvironment
		./hardware

		# .nix configs
    ./env.nix

		./applications.nix
		./programming.nix
    ./virtualization.nix
	];
}
