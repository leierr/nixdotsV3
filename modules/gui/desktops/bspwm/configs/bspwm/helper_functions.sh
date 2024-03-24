#!/usr/bin/env bash

function launch_once () {
	local newest_bspwm_socket=$(ls -t /tmp/bspwm*socket | head -n1)
	local start_time=$(stat -c '%Y' $newest_bspwm_socket)
	local current_time=$(date +%s)
	local diffrence=$(("$current_time-$start_time"))
	[[ "$diffrence" -lt "30" ]] && $@ &>/dev/null &
}

function launch_always () {
	pidof $1 &>/dev/null || $@ &>/dev/null &
}

function bspwm_mark_floating () {
	local PIDFILE="/tmp/bspwm_mark_floating.pid"
	function start_process() {
		bspc subscribe node_state | while read -r _ _ _ node state status; do
			if [[ "$state" == "floating" ]]; then
				case "$status" in
					off) xprop -id "$node" -remove _BSPWM_FLOATING_WINDOW;;
					on) xprop -id "$node" -f _BSPWM_FLOATING_WINDOW 8c -set _BSPWM_FLOATING_WINDOW "1";;
				esac
			fi
		done &
	}

	if [ -f $PIDFILE ]; then
		local PID=$(cat $PIDFILE)
		ps -p $PID &>/dev/null
		if [ $? -eq 0 ]; then
			echo "Process already running"
			return 1
		else
			start_process
			echo "$!" > /tmp/bspwm_mark_floating.pid
			if [ $? -ne 0 ]; then
				kill -9 $!
				echo "Could not create PID file"
				notify-send "Could not create PID file"
				return 1
			fi
		fi
	else
		start_process
		echo "$!" > /tmp/bspwm_mark_floating.pid
		if [ $? -ne 0 ]; then
			kill -9 $!
			echo "Could not create PID file"
			notify-send "Could not create PID file"
			return 1
		fi
	fi
}

function divide_workspaces () {
	desktops=(1 2 3 4 5 6 7 8 9 0)
	readarray -t monitor_list < <(bspc query -M)
	declare -A monitor_desktops

	for ((m=0;m<${#monitor_list[@]};m++)); do
		for ((d=$m; d<${#desktops[@]}; d+=${#monitor_list[@]})); do
			monitor_desktops[${monitor_list[$m]}]+=" ${desktops[d]}"
		done
		bspc monitor ${monitor_list[$m]} -d ${monitor_desktops[${monitor_list[$m]}]}
	done
	unset {desktops,monitor_list,monitor_desktops}
}

function launch_polybar () {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	if type "xrandr"; then
	  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	    MONITOR=$m polybar --reload main &>/dev/null &
	  done
	else
	  polybar --reload main &>/dev/null &
	fi
}
