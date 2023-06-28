#!/usr/bin/env bash
echo ~
echo $HOME
sed "s,~,$HOME," gitfiles | xargs -tL1 git clone
