#!/bin/bash

BIT_RATE=500k
PRESET=fast
IN_URL='http://camera-int.carltons.us/videostream.cgi?user=guest&pwd=guest'
STREAM_KEY=$(cat ~/.twitch_key)
# BANDWIDTH_TEST='?bandwidthtest=true'
STREAM_URL="rtmp://live.twitch.tv/app/$STREAM_KEY$BANDWIDTH_TEST"

# set -x

logfile="log.twitch.$(date +%F-%T)"

ffmpeg -loglevel warning \
 -f mjpeg -use_wallclock_as_timestamps 1 -i "$IN_URL" \
 -f flv -an -vcodec libx264 -x264opts keyint=2 -b:v "$BIT_RATE" -preset "$PRESET" "$STREAM_URL" \
 # &> "$logfile"
