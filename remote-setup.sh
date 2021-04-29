#!/usr/bin/env bash

echo "Installing dotfiles"

mkdir -p "$HOME/dev/dotfiles" &&
    eval "wget --no-check-certificate -O - https://github.com/ndz-v/dotfiles/tarball/wsl | tar -xzv -C $HOME/dev/dotfiles --strip-components=1"
eval "bash $HOME/dev/dotfiles/setup.sh 2>&1 | tee setup.log"
