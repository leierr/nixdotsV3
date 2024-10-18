{ pkgs, lib, inputs, ... }:
{
  system_settings.default_modules.enable = true;
  system_settings.user_account.username = "leier";
  system_settings.user_account.shell = pkgs.zsh;
  system_settings.shell.zsh.enable = true;
  system_settings.shell.starship.enable = true;
  system_settings.privilege_escalation.wheel_needs_password = false;
  system_settings.bluetooth.enable = true;

  system_settings.gui.enable = true;
  system_settings.gui.desktops.hyprland.enable = true;
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

      wayland.windowManager.hyprland.settings = {
          exec-once = [ "vesktop" ];
      };
    })
  ];

  # extra packages
  environment.systemPackages = with pkgs; [ pavucontrol fzf meld obsidian fastfetch spotify brave xfce.mousepad jq ];
}
