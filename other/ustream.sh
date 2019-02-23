#!/bin/bash

# available at: http://www.ustream.tv/channel/BfdwLWYju6k

BIT_RATE=500k
PRESET=fast
IN_URL='http://camera-int.carltons.us/videostream.cgi?user=guest&pwd=guest'
STREAM_KEY=$(cat ~/.ustream_key)
STREAM_URL="rtmp://1.23544088.fme.ustream.tv/ustreamVideo/23544088"

FORMAT=$1

set -x

# https://support.ustream.tv/hc/en-us/articles/207852457-Raspberry-Pi-Streaming-video-to-Ustream
#  raspivid -n -vf -hf -t 0 -w 960 -h 540 -fps 25 -b 500000 -o - | \
#  ffmpeg -i - -vcodec copy -an -metadata title="Streaming from raspberry pi camera" -f flv $RTMP_URL/$STREAM_KEY

# mpjeg, not working
#  ffmpeg -loglevel debug \
#    -f mjpeg -use_wallclock_as_timestamps 1 -i "$IN_URL" \
#    -f "$FORMAT" -an -vcodec libx264 -x264opts keyint=2 -b:v "$BIT_RATE" \
#    -preset "$PRESET" "$STREAM_URL/$STREAM_KEY"


RTSP_VIDEO_URL='rtsp://carlton:carlton1@camera2.carltons.us:88/videoMain'
RTSP_AUDIO_URL='rtsp://carlton:carlton1@camera2.carltons.us:88/audio'

# ffmpeg -i "$RTSP_VIDEO_URL" -i "$RTSP_AUDIO_URL" -vcodec copy -acodec copy -f flv $STREAM_URL/$STREAM_KEY
# ffmpeg -i "$RTSP_VIDEO_URL" -i "$RTSP_AUDIO_URL" -vcodec copy -f flv $STREAM_URL/$STREAM_KEY
ffmpeg -i "$RTSP_VIDEO_URL" -vcodec copy -acodec copy -f flv $STREAM_URL/$STREAM_KEY
