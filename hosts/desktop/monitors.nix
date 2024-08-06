{
  systemd.tmpfiles.rules = let
    gdm_monitor_config_multiline = ''
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>1</scale>
            <monitor>
              <monitorspec>
                <connector>DP-2</connector>
                <vendor>AOC</vendor>
                <product>Q27G2G4</product>
                <serial>0x000021bd</serial>
              </monitorspec>
              <mode>
                <width>2560</width>
                <height>1440</height>
                <rate>143.912</rate>
              </mode>
            </monitor>
          </logicalmonitor>
          <logicalmonitor>
            <x>2560</x>
            <y>0</y>
            <scale>1</scale>
            <primary>yes</primary>
            <monitor>
              <monitorspec>
                <connector>DP-1</connector>
                <vendor>AOC</vendor>
                <product>Q27G2G4</product>
                <serial>0x000023bd</serial>
              </monitorspec>
              <mode>
                <width>2560</width>
                <height>1440</height>
                <rate>143.912</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    '';

    # Trimming
    gdm_monitor_config_trimmed = builtins.replaceStrings ["\n" "  "] [" " ""] gdm_monitor_config_multiline;
  in [
    "f+ /run/gdm/.config/monitors.xml - gdm gdm - ${gdm_monitor_config_trimmed}"
  ];

  services.xserver.xrandrHeads = [
    {
      output = "DisplayPort-1";
      primary = true;
      monitorConfig = ''
        Option "Position" "0 0"
        Option "Enable" "true"
        Option "Rotate" "normal"
        Option "PreferredMode" "2560x1440_144"
      '';
    }
    {
      output = "DisplayPort-0";
      monitorConfig = ''
        Option "Position" "2560 0"
        Option "Enable" "true"
        Option "Rotate" "normal"
        Option "PreferredMode" "2560x1440_144"
      '';
    }
  ];
}
