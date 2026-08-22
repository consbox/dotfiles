#!/bin/sh

WALLPAPER_PATH="$HOME/Pictures/atoms.png"

test -f ~/.Xresources && xrdb -merge -I$HOME ~/.Xresources

setxkbmap -option caps:escape

xss-lock --transfer-sleep-lock -- slock &

xhidecursor &
dunst &
xset r rate 250 50 &

feh --no-fehbg --bg-fill ${WALLPAPER_PATH}

# launch dbus-session
if command -v dbus-launch >/dev/zero && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

emacs --daemon &

slstatus &
dwm
