{ cfg }:
{
  security.doas = {
    enable = true;
    wheelNeedsPassword = cfg.wheel_needs_password;
  };

  # sudo -> doas alias
  environment.interactiveShellInit = ''alias sudo="doas"'';

  security.sudo.enable = false;
}
