#!/bin/bash
#
# $1 = filter cmd to run, including args
# $2 = HalideTraceViz executable
# $3 = path to output mp4

rm -rf "$3"

# Use a named pipe for the $1 -> HTV pipe, just in case
# the exe in $1 writes any random output to stdout.
PIPE=/tmp/halide_viz_auto_pipe
rm -rf $PIPE
mkfifo $PIPE

HL_TRACE_FILE=${PIPE} HL_NUMTHREADS=8 $1 &

"$2" --auto_layout --size 1920 1080 0<${PIPE} | \
avconv -y -f rawvideo -pix_fmt bgr32 -s 1920x1080 -i /dev/stdin -c:v h264 "$3"
#mplayer -demuxer rawvideo -rawvideo w=1920:h=1080:format=rgba:fps=30 -idle -fixed-vo -
