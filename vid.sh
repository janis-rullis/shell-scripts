#!/bin/bash

# https://linux4one.com/how-to-install-ffmpeg-on-ubuntu-18-04/
# sudo cp vid.sh /usr/local/bin/vid
# sudo chmod a+x /usr/local/bin/vid

echo "== Create a video from images with a music ==";
size=1920:1080;

if [[ -n $1 ]]; then
        size=$1;
fi

# https://video.stackexchange.com/a/23532
ffmpeg -framerate 1/10 -i img-%04d.jpg -r 100 -pix_fmt yuv420p out.mp4

# https://www.youtube.com/watch?v=lE1y_TTISTQ
ffmpeg -i out.mp4 -i /usr/local/bin/audio.mp3 -c copy -shortest out_with_audio.mp4