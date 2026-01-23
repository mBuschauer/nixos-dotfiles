{ pkgs, ... }:
{
    services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      global = {
        follow = "mouse";
        shrink = "yes";
        # mouse = true;
        notification_height = 0;

        # Text and seperator padding
        padding = 8;
        # Horizontal padding
        horizontal_padding = 8;

        # Split notifications into multiple lines
        word_wrap = "no";
        # If message too long, add ellipsize to...
        ellipsize = "middle";
        # Ignore newlines in notifications
        ignore_newline = "no";
        # Stack duplicate notifications
        stack_duplicates = true;
        # Hide number of duplicate notifications
        hide_duplicate_count = true;

        mouse_left_click = "do_action";
        mouse_right_click = "close_menu";

        dmenu = "${pkgs.dmenu-rs}/bin/dmenu -l 10 -w 10 -p dunst";
        # dmenu = "${pkgs.wofi}/bin/wofi --demnu --prompt \"dunst\" --insensitive";
        # Browser
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        # Always run scripts
        always_run_script = true;
        # Print notification on startup
      };

    };
  };
}