#!/bin/sh
# Run inside your media/ folder (needs ffmpeg). Writes optimized copies into ./optimized/
# then replace the originals with them. Videos get: max 800px tall, smaller bitrate, fast-start
# (plays before it finishes downloading), mono audio. JPG posters get recompressed.
mkdir -p optimized
for f in *.mp4; do
  ffmpeg -y -v error -i "$f" -vf "scale=-2:'min(800,ih)'" -c:v libx264 -crf 30 -preset slow -profile:v main -pix_fmt yuv420p -movflags +faststart -c:a aac -b:a 48k -ac 1 "optimized/$f"
done
for f in *.jpg; do
  ffmpeg -y -v error -i "$f" -q:v 5 "optimized/$f"
done
echo "Done: check the optimized/ folder, then copy its files over the originals."
