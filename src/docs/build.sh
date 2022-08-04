#!/bin/bash

## Start off by setting shell options / getting consts.
shopt -s nullglob
declare -r script_dir=$(realpath $(dirname "$0"))

## Install dependencies.
(which luarocks > /dev/null 2>&1) || sudo apt-get install -y --force-yes lua5.1 luarocks
# Yes, we don't use ldoc here, but we use its dependencies, so we install it here.
(which ldoc > /dev/null 2>&1) || sudo luarocks install ldoc

"$script_dir/template/style/build.sh"
"$script_dir/ldoc/ldoc.lua" -c src/docs/config.ld .
