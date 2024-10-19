{ config, pkgs, ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  boot = {
    kernelModules = [
      "acpi_call" # Useful for power management, especially for turning off the discrete GPU if needed.
    ];

    initrd = {
      verbose = false;
      kernelModules = [
        "i915" # Intel graphics driver for integrated graphics (needed for boot display).
      ];
      availableKernelModules = [
        "xhci_pci" # USB 3.0 support.
        "ahci" # SATA controller driver (essential for your internal SSD).
        "usb_storage" # If you use USB drives frequently.
        "usbhid" # USB keyboard and mouse support (typically needed for external peripherals).
        "sd_mod" # SCSI disk support (includes SATA drives).
        # "dm_mod" # Required for LVM/encryption.
        # "thunderbolt" # Thunderbolt devices.
      ];
    };

    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;  # Installs and applies Intel microcode updates for CPU fixes and security patches.
    enableRedistributableFirmware = true;  # Enables firmware that isn't part of the open-source kernel, required for some hardware devices.

    opengl = {
      enable = true;  # Enables OpenGL for 3D rendering and graphics acceleration.
      driSupport = true;  # Direct Rendering Infrastructure (DRI) support for better graphics performance.
      driSupport32Bit = true;
      extraPackages = with pkgs; [  
        intel-vaapi-driver  # Video Acceleration API (VAAPI) driver for Intel hardware to accelerate video processing.
        intel-media-driver  # Additional media driver for Intel hardware, improving video encoding/decoding.
      ];
    };

    trackpoint.enable = true;  # Enables support for the TrackPoint (the small red dot used as a pointing device on ThinkPads).
    trackpoint.emulateWheel = true; # Enable scrolling while holding the middle mouse button.
    #hardware.trackpoint.sensitivity = 200;  # Optionally adjusts the sensitivity of the TrackPoint device, if uncommented.
  };

  powerManagement.cpuFreqGovernor = "powersave";

  services.fstrim.enable = true; # SSD optimization
  services.fwupd.enable = true;  # Firmware updates

  #services.logind.extraConfig = ''
  #  HandleSuspendKey=suspend
  #  HandleLidSwitch=suspend
  #  HandleHibernateKey=hibernate
  #'';
}
