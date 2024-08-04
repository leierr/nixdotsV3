{ cfg, lib }:
{
  security.doas = {
    enable = true;
    wheelNeedsPassword = cfg.wheel_needs_password;
    extraRules = lib.mkForce [{
        groups = [ "wheel" ];
        noPass = !cfg.wheel_needs_password;
        keepEnv = true;
    }];
  };

  # sudo -> doas alias
  environment.interactiveShellInit = ''alias sudo="doas"'';

  security.sudo.enable = false;
}
