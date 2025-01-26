#!/usr/bin/env bash
set -e
inputfile="$(ls /input/*)"
echo "Entered container. The input file is "$inputfile" which is $(du -h "$inputfile" | cut -f1) big."
frame_count="$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 "$inputfile")"
mkdir -p /output/JPEGImages
image_count="$(ls /output/JPEGImages | wc -l)"
echo "The input file has $frame_count frames. There are $image_count JPEGs in the output folder already."
if [ "$frame_count" -eq "$image_count" ]; then
  echo "The number of frames and JPEGs match. Not splitting the video again."
else
  if [ "$image_count" -ne 0 ]; then
    echo "The output folder is not clean. Aborting."
    exit 1
  else
    echo "Splitting the video into frames."
    ffmpeg -i "$inputfile" -q:v 1 /output/JPEGImages/%08d.jpg
  fi
fi
echo "Running RAFT inference."
. ~/miniconda3/bin/activate
conda activate raft
# NOTE won't work if not called from /raft/flowsam/flow
cd /raft/flowsam/flow
python run_inference.py