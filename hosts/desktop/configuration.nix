{ pkgs, lib, inputs, ... }:
{
  system_settings.default_modules.enable = true;
  system_settings.user_account.username = "leier";
  system_settings.user_account.shell = pkgs.zsh;
  system_settings.shell.zsh.enable = true;
  system_settings.shell.starship.enable = true;
  system_settings.virtualization.libvirt.enable = true;
  system_settings.virtualization.libvirt.virt_manager.enable = true;
  system_settings.privilege_escalation.wheel_needs_password = false;
  system_settings.bluetooth.enable = true;

  system_settings.gui.enable = true;
  system_settings.gui.desktops.gnome.enable = false;
  system_settings.gui.desktops.hyprland.enable = true;
  system_settings.gui.gaming.enable = true;
  system_settings.gui.discord.enable = true;

  # overwriting home-manager values
  home_manager_modules = [
    ({
      programs.git.includes = [
        {
          condition = "hasconfig:remote.*.url:git@github.com:*/**";
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
        userSettings = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "security.workspace.trust.enabled" = false;
          "git.enableSmartCommit" = true;
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "explorer.confirmDelete" = false;
          "explorer.confirmDragAndDrop" = false;
          "colorize.colorized_colors" = ["BROWSERS_COLORS" "HEXA" "RGB" "HSL"];
          "colorize.colorized_variables" = ["CSS"];
          "colorize.exclude" = ["**/.git" "**/.svn" "**/.hg" "**/CVS" "**/.DS_Store" "**/.git" "**/node_modules" "**/bower_components" "**/tmp" "**/dist" "**/tests"];
          "colorize.include" = ["**/*.nix" "**/*.css" "**/*.scss" "**/*.sass" "**/*.less" "**/*.styl"];
        };
      };

      # increase the gnome text size a bit
      dconf.settings."org/gnome/desktop/interface".text-scaling-factor = 1.1;
      # scale cursor to bigger display
      system_settings.gui.cursor.size = 32;

      programs.rbw = {
        enable = true;
        settings = {
          email = "lars.smith.eier@basefarm-orange.com";
          lock_timeout = 36000;
        };
      };

      wayland.windowManager.hyprland.settings = {
          general.border_size = lib.mkForce 3;
          windowrulev2 = [
            "monitor DP-2, class:^(vesktop)$"
          ];
          exec-once = [
            "vesktop"
            "${pkgs.writeShellScript "launch-slack-if-work-hours" "[[ $(date +%u) -le 5 && $(date +%H%M | sed 's/^0*//') -ge 600 && $(date +%H%M | sed 's/^0*//') -le 1500 ]] && slack"}"
          ];
      };
    })
  ];

  # extra packages
  environment.systemPackages = with pkgs; [ slack pavucontrol fzf meld obsidian obs-studio fastfetch spotify remmina brave xfce.mousepad gnome.totem jq ];
}
