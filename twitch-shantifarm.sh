#!/bin/bash

STREAM_KEY=$(cat ~/.twitch_key)
# BANDWIDTH_TEST='?bandwidthtest=true'

LOGFILE="log.twitch-shantifarm.$(date +%F-%T)"

STREAM_URL="rtmp://live.twitch.tv/app/$STREAM_KEY$BANDWIDTH_TEST"

# Foscam R2
# 	h264 1280x720 @ 15 fps
# 	PCM ulaw 8kh 16b

RTSP_VIDEO_URL='rtsp://carlton:carlton1@camera2.carltons.us:88/videoMain'
# RTSP_AUDIO_ONLY_URL='rtsp://carlton:carlton1@camera2.carltons.us:88/audio'

# this re-encodes as h264, not needed and costs >30% CPU
# see x264 --fullhelp
# BIT_RATE=500k
# PRESET=fast		# fast, veryfast, superfast, ultrafast
# VIDEO_OPTIONS='-vcodec libx264 -x264opts keyint=2 -b:v "$BIT_RATE" -preset "$PRESET"'

VIDEO_OPTIONS='-vcodec copy'	# the input stream is already h264, so just copy it through
AUDIO_OPTIONS='-acodec aac'	# need to transcode the audio, ulaw isn't supported

# orig: ffmpeg -loglevel warning -i "$RTSP_VIDEO_URL" -copytb 1 -vcodec copy -acodec copy -f flv $STREAM_URL

while true; do
    # ffmpeg crashes occasionally, so pause and restart it

    echo "starting ffmpeg"
    ffmpeg -loglevel warning -copytb 1 \
	   -rtsp_transport tcp -i "$RTSP_VIDEO_URL" \
 	   -f flv $AUDIO_OPTIONS $VIDEO_OPTIONS \
	   $STREAM_URL &> "$LOGFILE"
    sleep 10
done
