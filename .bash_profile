#!/bin/bash

if test "$(tty)" = "/dev/tty1"; then
    start-hyprland
fi
