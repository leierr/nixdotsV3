{ lib }:(
let
  hexToDecMap = {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
    "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
    "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
  };

  hexCharToDec = c: hexToDecMap.${lib.strings.toLower c};

  hexPairToDec = pair: hexCharToDec (lib.strings.substring 0 1 pair) * 16 + hexCharToDec (lib.strings.substring 1 2 pair);

  hexToRGB = hex: {
    r = hexPairToDec (lib.strings.substring 1 2 hex);
    g = hexPairToDec (lib.strings.substring 3 2 hex);
    b = hexPairToDec (lib.strings.substring 5 2 hex);
  };

  rgbToRGBAString = rgb: "rgba(${toString rgb.r}, ${toString rgb.g}, ${toString rgb.b}, 1)";
in
  hexToRGBA: rgbToRGBAString (hexToRGB hex)
)
