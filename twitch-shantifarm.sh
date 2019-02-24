#!/usr/bin/env bash
#
# Copyright 2019 Mike Carlton
#
# Released under terms of the MIT License:
#   http://www.opensource.org/licenses/mit-license.php
#
# Place this file in /usr/local/bin/twitch-shantifarm.sh

# import STREAM_KEY, CAM_USER, CAM_PASS
# .twitch_env should look like:
# export STREAM_KEY=live_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# export CAM_USER=XXXXX
# export CAM_PASS=XXXXX
source ${HOME}/.twitch-shantifarm.env

# optional:
# BANDWIDTH_TEST='?bandwidthtest=true'
# LOGFILE="log.twitch-shantifarm.$(date +%F-%T)"

STREAM_URL="rtmp://live.twitch.tv/app/$STREAM_KEY$BANDWIDTH_TEST"

# designed for
# Foscam R2
#   h264 1280x720 @ 15 fps
#   PCM ulaw 8kh 16b

RTSP_VIDEO_URL="rtsp://${CAM_USER}:${CAM_PASS}@camera2.carltons.us:88/videoMain"
# RTSP_AUDIO_ONLY_URL="rtsp://${CAM_USER}:${CAM_PASS}@camera2.carltons.us:88/audio"

VIDEO_OPTIONS='-vcodec copy'  # the input stream is already h264, so just copy it through
AUDIO_OPTIONS='-acodec aac'   # need to transcode the audio, ulaw isn't supported by twitch
LOG_OPTIONS='-loglevel fatal' # fatal, error, warning, quiet
TRANSPORT_OPTIONS='-rtsp_transport tcp' # TCP transport is critical to avoid dropouts

# note that ffmpeg has a tendency to periodically exit (typically with error code 1)
# we also force a periodic timeout to molify twitch
# the caller of this script needs to ensure it restarts
exec timeout 24h /usr/bin/ffmpeg -nostdin $LOG_OPTIONS -copytb 1 \
       $TRANSPORT_OPTIONS -i "$RTSP_VIDEO_URL" \
       -f flv $AUDIO_OPTIONS $VIDEO_OPTIONS \
       $STREAM_URL # &> "$LOGFILE"
