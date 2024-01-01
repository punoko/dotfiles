#!/usr/bin/env zsh

SCRIPT=$(realpath $0)
DOTDIR=$(dirname $SCRIPT)

[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc"{,_old}
ln -sf "$DOTDIR/.zshrc" "$HOME/.zshrc"
