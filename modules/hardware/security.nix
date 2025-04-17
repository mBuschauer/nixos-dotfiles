{ pkgs, settings, ... }: 

{
  security.pam = {
    package = pkgs.pam;
    services = {
      ${settings.userDetails.username} = {
        kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
        };
      };
    };
  };
}
