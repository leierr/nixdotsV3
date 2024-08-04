{ pkgs, ... }:
{
  system_settings.default_modules.enable = true;
  system_settings.user_account.username = "leier";
  system_settings.user_account.shell = pkgs.zsh;
  system_settings.shell.zsh.enable = true;
  system_settings.shell.starship.enable = true;

  system_settings.gui.enable = true;
  system_settings.gui.desktops.bspwm.enable = true;
  system_settings.gui.desktops.gnome.enable = true;
  system_settings.gui.desktops.hyprland.enable = true;
  system_settings.gui.gaming.enable = true;

  system_settings.privilege_escalation.wheel_needs_password = false;

  system_settings.bluetooth.enable = true;

  # disable root password
  users.users.root.hashedPassword = "!";

  # overwriting home-manager values
  home_manager_modules = [
    ({
      programs.git.includes = [
        {
          condition = "gitdir:remote.*.url=git@github.com:";
          contents = {
            user = {
              name = "Lars Smith Eier";
              email = "hBm5BEqULhwPKUY@protonmail.com";
            };
          };
        }
      ];

      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix # nix syntax highlighting
        ];
      };

      # increase the gnome text size a bit
      dconf.settings."org/gnome/desktop/interface".text-scaling-factor = 1.1;

      # hyprland automagical screen config
      services.kanshi = {
        enable = true;
        systemdTarget = "hyprland-session.target";
        settings = [
          {
            profile.name = "main";
            profile.outputs = [
              {
                criteria = "AOC Q27G2G4 0x000023BD"; # hyprctl monitors, description
                position = "2560,0";
                mode = "2560x1440@143.91Hz";
              }
              {
                criteria = "AOC Q27G2G4 0x000021BD"; # hyprctl monitors, description
                position = "0,0";
                mode = "2560x1440@143.91Hz";
              }
            ];
          }
        ];
      };
    })
  ];

  # extra packages
  environment.systemPackages = [];
}
