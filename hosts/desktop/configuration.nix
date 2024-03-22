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
    privilege_escalation.program = "doas";
    privilege_escalation.wheel_needs_password = false;
  };

  # testing
  system_settings.gtk.enable = true;
  system_settings.qt.enable = true;
  system_settings.pinentry.enable = true;

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize =  8192;
      cores = 8;
    };
  };
}
