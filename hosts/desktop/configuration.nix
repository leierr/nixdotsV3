{
  system_settings = {
    boot_loader.type = "grub";
    user_account = {
      username = "leier";
      description = "Lars Smith Eier";
    };

    virtualization = {
      docker.enable = true;
      libvirt.enable = true;
    };

    privilege_escalation = {
      program = "doas";
      wheel_needs_password = false;
    };

    gui = {
      enable = true;
      display_manager.program = "gdm";
      display_manager.default_session = null;
    };

    git = {
      enable = true;
      includes = [
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
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize =  8192;
      cores = 8;
      qemu.options = ["-vga cirrus"];
    };
  };
}
