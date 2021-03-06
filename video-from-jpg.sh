#!/bin/bash

# https://linuxconfig.org/ubuntu-20-04-ffmpeg-installation
# sudo ln -s ~/Desktop/www/shell-scripts/video-from-jpg.sh /usr/local/bin/video-from-jpg && sudo chmod a+x /usr/local/bin/video-from-jpg
# sudo ln -s /home/j/Desktop/www/content_gen/audio.mp3 /usr/local/bin/audio.mp3

echo "== Create a video from images with a music ==";
size=1920:1080;

if [[ ! -n $1 ]]; then
  echo 'Description?';
  exit;
fi
DESCRIPTION=$1;

if [[ -n $2 ]]; then
        size=$2;
fi

# https://video.stackexchange.com/a/23532
ffmpeg -framerate 1/10 -i img-%04d.jpg -r 100 -pix_fmt yuv420p "${DESCRIPTION}.mp4"

# #4 https://www.youtube.com/watch?v=lE1y_TTISTQ
ffmpeg -i "${DESCRIPTION}.mp4" -i /usr/local/bin/audio.mp3 -c copy -shortest "${DESCRIPTION}_with_audio.mp4"
