{
  programs.hyprpaper = {
    # disable IPC because I dont need it + battery consumption
    ipc = false;
    splash = false;
    preloads = [ "${./wallpaper.jpg}" ];
    wallpapers = [ ",${./wallpaper.jpg}" ];
  };
}
