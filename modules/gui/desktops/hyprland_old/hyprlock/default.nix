{ cfg, theme, hexToRGBA }:
{
  programs.hyprlock.enable = true;
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
        path = "${./nix_logo.png}";
        size = 150;
        rounding = -1; # circle
        border_size = 4;
        border_color = "${hexToRGBA theme.primary_color}";
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
        outer_color = "${hexToRGBA theme.primary_color}";
        inner_color = "${hexToRGBA theme.bg}";
        font_color = "${hexToRGBA theme.bg}";
        fade_on_empty = false;
        placeholder_text = ''<span foreground="${hexToRGBA theme.bg2}"><i>󱅞 Logged in as $USER</span>'';
        hide_input = false;
        #rounding
        check_color = "${hexToRGBA theme.primary_color}";
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
