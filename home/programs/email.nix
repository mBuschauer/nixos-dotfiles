{ config, pkgs, secrets, ... }:

{
  # Enable himalaya
  programs.himalaya.enable = true;
  
  accounts.email.accounts = {
    umd = {
      primary = true;
      address = "${secrets.privateEmail}";
      realName = "${secrets.realName}";
      userName = "${secrets.privateEmail}";
      passwordCommand = "echo ${secrets.gmailPass}";
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls.enable = true;
      };

      himalaya.enable = true;
    };

    gmail = {
      address = "${secrets.schoolEmail}";
      realName = "${secrets.realName}";
      userName = "${secrets.schoolEmail}";
      passwordCommand = "echo ${secrets.schoolPassword}";
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls.enable = true;
      };

      himalaya.enable = true;
    };
  };
}