#!/usr/bin/env bash

ssh-keygen -t ed25519 -C "krngle@gmail.com" -f ~/.ssh/id_ed25519 -N '' <<< y
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
