#!/bin/sh

if test -z $1; then
	echo "Usage: giffy <in.ogv> <out.gif> <start second> <duration>"
	exit
fi

src=$1
dest=$2
start_time=$3
duration=$4

palette="/tmp/palette.png"

# filters="fps=20,scale=400:-1"
filters="fps=15"

/Test/ffmpeg-3.2-64bit-static/ffmpeg -v warning -ss $start_time -t $duration -i $src -vf "$filters,palettegen" -y $palette
/Test/ffmpeg-3.2-64bit-static/ffmpeg -v warning -ss $start_time -t $duration -i $src -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $dest
