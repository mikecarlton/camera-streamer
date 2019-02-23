#!/bin/bash

# available at: http://youtube.com/channel/UCiyceI-4ci9cG2-EFhN9e2g/live

BIT_RATE=500k
PRESET=fast
IN_URL='http://camera-int.carltons.us/videostream.cgi?user=guest&pwd=guest'
STREAM_KEY=$(cat ~/.youtube_key)
STREAM_URL="rtmp://a.rtmp.youtube.com/live2"
CONTAINER="flv"

set -x

ffmpeg -loglevel info \
 -f mjpeg -use_wallclock_as_timestamps 1 -i "$IN_URL" \
 -f "$CONTAINER" -an -vcodec libx264 -pix_fmt yuv420p -x264opts keyint=2 \
 -b:v "$BIT_RATE" -preset "$PRESET" "$STREAM_URL/$STREAM_KEY"
