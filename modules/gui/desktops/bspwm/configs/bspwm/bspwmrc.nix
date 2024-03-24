''
# ] ---- IMPORTS ---- [
source ${./helper_functions.sh}

# ] ---- WORKSPACES ---- [ 

divide_workspaces

# ] ---- CONFIG ---- [

# rules
bspc rule -a "Screenkey" manage=off
bspc rule -a "alacritty:floaty" state=floating center=true
bspc rule -a "*:nm-connection-editor" state=floating center=true
bspc rule -a "gnome-calculator:gnome-calculator" state=floating center=true
bspc rule -a "*:pavucontrol" state=floating center=true
bspc rule -a ".arandr-wrapped:.arandr-wrapped" state=floating center=true

# special launch scripts
# launch_polybar
# bspwm_mark_floating

# autostart
#launch_once bspc rule -a firefox desktop="2" -o ; launch_once firefox
#launch_always dunst
#launch_always flameshot
#launch_always nm-applet
#launch_always sxhkd
#launch_always picom --config "${BSPWM_CONFIG}/picom.conf"
#launch_always pinentry
#launch_always pasystray --notify=none

# work time! monday-friday 07:00-15:30
#if [[ $(date +"%u") -le 5 && $(date +"%H%M") < "1530" && $(date +"%H%M") > "0700" ]] ; then
#    launch_once bspc rule -a Slack desktop="1" -o
#    launch_once bspc rule -a discord desktop="1" -o
#    launch_once bspc config ignore_ewmh_focus true
#    launch_once slack
#    launch_once discord
#    launch_once bash -c "sleep 3; bspc config ignore_ewmh_focus false"
#else
#    launch_once bspc rule -a discord desktop="1" -o
#    launch_once bspc config ignore_ewmh_focus true
#    launch_once discord
#    launch_once bash -c "sleep 3; bspc config ignore_ewmh_focus false"
#fi

# background
${pkgs.feh}/bin/feh --bg-scale "${../../assets/wallpaper.png}"

# mouse
${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
bspc config click_to_focus button1
bspc config pointer_follows_monitor true

# windows and borders
bspc config border_width 2
bspc config window_gap 10
bspc config single_monocle true
bspc config borderless_monocle true
bspc config gapless_monocle true

# colors
bspc config presel_feedback_color "#1081d6"
bspc config normal_border_color "#30363d"
bspc config active_border_color "#30363d"
bspc config focused_border_color "#1081d6"
bspc config remove_disabled_monitors true
bspc config remove_unplugged_monitors true
''
