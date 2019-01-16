#!/bin/bash
if [ x"$1" = x"help" -o x"$1" = x"--help" -o x"$1" = x"-help" ];then
echo "Usage: playseries [folder path]"
echo "Audio mode can be either 'hdmi' or 'local'."
echo "Folder path is the full path to folder full of video files."
echo "This script will try to play all files in the video folder regardless of file type"
exit
fi
while true
do
for file in $(shuf -e  $2/* )
do
omxplayer -o $1 $file --orientation $2  --aspect-mode stretch
done
done