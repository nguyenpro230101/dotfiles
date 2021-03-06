#!/usr/bin/env bash

# You can call this script like this:
# $ ./volumeControl.sh up
# $ ./volumeControl.sh down
# $ ./volumeControl.sh mute

# Script modified from these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

function get_volume {
  amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
  amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
  iconSound="墳"
  iconMuted="婢"
  if is_mute ; then
    dunstify  -r 2593 -u normal "$iconMuted Mute"
  else
    volume=$(get_volume)
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq --separator="⣿" 0 "$((volume / 5))" | sed 's/[0-9]//g')
    spaces=$(seq --separator="⠀" 0 "$(( 20 - (volume / 5) ))" | sed 's/[0-9]//g')
    # bar=$(seq --separator="─" 0 "$((volume / 5))" | sed 's/[0-9]//g')
    # spaces=$(seq --separator=" " 0 "$(( 20 - $(volume / 5) ))" | sed 's/[0-9]//g')
    # Send the notification
    dunstify  -r 2593 -u normal "$iconSound  $bar$spaces"
  fi
}

case $1 in
  up)
    # set the volume on (if it was muted)
    amixer -D pulse set Master on > /dev/null
    # up the volume (+ 5%)
    amixer -D pulse sset Master 5%+ > /dev/null
    send_notification
    ;;
  down)
    amixer -D pulse set Master on > /dev/null
    amixer -D pulse sset Master 5%- > /dev/null
    send_notification
    ;;
  mute)
    # toggle mute
    amixer -D pulse set Master 1+ toggle > /dev/null
    send_notification
    ;;
esac
