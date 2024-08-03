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
  system_settings.gui.gaming.enable = true;

  system_settings.privilege_escalation.wheel_needs_password = false;

  system_settings.bluetooth.enable = true;

  # disable root password
  users.users.root.hashedPassword = "!";

  programs.hyprland.enable = true;

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
    })
  ];

  # extra packages
  environment.systemPackages = [
    pkgs.vscodium
  ];
}
