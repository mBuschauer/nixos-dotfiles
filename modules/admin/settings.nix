{ ... }:
{
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
  };

 # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

	nix.gc = {
		automatic = true;
		dates = "daily";
		options = "--delete-older-than 2d";
	};

  nix.optimise.automatic = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enab
  # };
}
