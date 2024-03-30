{
  system_settings.default_modules.enable = true;
  system_settings.user_account.username = "leier";
  system_settings.git.includes = [
    {
      condition = "hasconfig:remote.*.url:git@github.com:**/**";
      contents = {
        user = {
          name = "Lars Smith Eier";
          email = "hBm5BEqULhwPKUY@protonmail.com";
        };
      };
    }
  ];
  system_settings.gui.enable = true;
  system_settings.gui.desktops.bspwm.enable = true;

  system_settings.nixos.allow_unfree = true;

  system_settings.privilege_escalation.wheel_needs_password = false;

  system_settings.terminal_utils.locate.enable = true;
  system_settings.terminal_utils.gnupg.enable = true;
  system_settings.terminal_utils.editor.program = "neovim";

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize =  8192;
      cores = 8;
      qemu.options = ["-vga cirrus"];
    };
  };
}
