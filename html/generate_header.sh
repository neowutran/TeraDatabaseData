#!/bin/bash
IFS=$'\n'
dungeons=$(./generate_dungeons_name.sh)
header=$(cat ./_header)
echo "${header/include_dungeons/$dungeons}" > header.html
