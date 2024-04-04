{ cfg, theme }:
{
  programs.hyprlock = {
    general = {
      no_fade_in = true;
      no_fade_out = true;
      disable_loading_bar = true;
      hide_cursor = true;
    };

    backgrounds = [
      {
        monitor = "";
        path = "${./background.png}";
        blur_size = 0;
      }
    ];

    images = [
      {
        monitor = "";
        path = cfg.hyprlock.profile_pic ? "${./nix_logo.png}";
        size = 150;
        rounding = -1; # circle
        border_size = 4;
        border_color = "${theme.primary_color.rgba}";
        position.x = 0;
        position.y = 250;
        halign = "center";
        valign = "center";
      }
    ];

    input-fields = [
      {
        size.width = 300;
        size.height = 60;
        outline_thickness = 4;
        dots_size = 0.2;
        dots_spacing = 0.2;
        outer_color = "${theme.primary_color.rgba}";
        inner_color = "${theme.bg.rgba}";
        font_color = "${theme.bg.rgba}";
        fade_on_empty = false;
        placeholder_text = ''<span foreground="##$textAlpha"><i>󱅞 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
        hide_input = false;
        #rounding
        check_color = "${theme.primary_color.rgba}";
        fail_color = "rgba(255, 46, 46, 1)";
        fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
        #fail_transition
        position.x = 0;
        position.y = -35;
        halign = "center";
        valign = "center";
      }
    ];
  };
}
