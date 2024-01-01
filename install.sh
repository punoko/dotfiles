#!/usr/bin/env zsh

SCRIPT=$(realpath $0)
DOTDIR=$(dirname $SCRIPT)
KERNEL=$(uname -s)
function isdarwin() [[ $KERNEL == "Darwin" ]]
function islinux() [[ $KERNEL == "Linux" ]]

ln -s "$DOTDIR/zshrc" "$HOME/.zshrc"

CONFDIR=".config"

for item in "mpv" "wezterm" "zed"; do
	ln -s "$DOTDIR/$item" "$HOME/$CONFDIR/"
done

for item in "streamlink"; do
	isdarwin && CONFDIR="Library/Application Support"
	ln -s "$DOTDIR/$item" "$HOME/$CONFDIR/"
done
