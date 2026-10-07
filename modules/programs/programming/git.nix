# home-manager import
{
  pkgs,
  secrets,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "${secrets.gitUser}";
        email = "${secrets.gitEmail}";
      };
      merge = {
        "ours" = {
          driver = true;
        };
      };
      submodule = {
        recurse = true;
      };
    };
    signing = {
      format = "openpgp";
      signer = "${pkgs.gnupg}/bin/gpg";
      key = "${secrets.gpgFingerprint}"; # gpg --list-keys --fingerprint
      signByDefault = true;
    };
  };
}
