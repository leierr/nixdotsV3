{
  system_settings = {
    default_modules.enable = true;
    git = {
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
