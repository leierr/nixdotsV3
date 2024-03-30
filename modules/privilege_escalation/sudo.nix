{cfg}:
{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = cfg.wheel_needs_password;
  };

  security.doas.enable = false;
}
