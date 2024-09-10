{inputs, pkgs, ...}:
{
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages."${pkgs.system}".hyprlock;
    settings = {
      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          dots_size = 0.26;
          dots_spacing = 0.64;
          fade_on_tempty = true;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, 100";
          halign = "center";
          valign = "bottom";
        }
      ];
      label = [
        { # current time
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big> \"$(date +'%H:%M:%S')\" </big></b>\"";
          font_size = 64;
          font_family = "Jetbrains Mono Nerd Font 10";
          shadow_passes = 3;
          shadow_size = 4;
          position = "0, 30";
          halign = "center";
          valign = "center";
        }
        {   #date
          monitor = "";
          text = "cmd[update:180000000] echo \"<b> \"$(date +'%A, %-d %B %Y')\" </b>\"";
          font_size = 24;
          font_family = "Jetbrains Mono Nerd Font 10";
          position = "0, -30";
          halign = "center";
          valign = "center";
        }
      ]; 
    };
  };
}
