#!/usr/bin/env bash
# Run this on YOUR computer (Mac/Linux, or Windows via Git Bash/WSL) inside your website folder.
# Needs: yt-dlp and ffmpeg   ->  pip install yt-dlp   |   https://ffmpeg.org
# If Instagram asks you to log in, add:  --cookies-from-browser chrome   to the yt-dlp line.
set -e
mkdir -p media
URLS=(
https://www.instagram.com/reel/DP_dU83DJnk/
https://www.instagram.com/reel/DUPxS2iEs_F/
https://www.instagram.com/reel/DSZXnobjYqL/
https://www.instagram.com/reel/DRWjdNijUoX/
https://www.instagram.com/p/DP1eMsniu9E/
https://www.instagram.com/reel/DNdOw3HIGDq/
https://www.instagram.com/reel/DHEVkV5oIv5/
https://www.instagram.com/reel/DH_RjppITL1/
https://www.instagram.com/reel/DLTD8sXN3JJ/
)
i=1
for u in "${URLS[@]}"; do
  n=$(printf "%02d" $i)
  echo "== reel-$n"
  yt-dlp -f "mp4/best" -o "media/raw-$n.%(ext)s" "$u"
  # web-friendly mp4, max 720 wide, plays everywhere
  ffmpeg -y -loglevel error -i media/raw-$n.* -vf "scale='min(720,iw)':-2" -c:v libx264 -crf 26 -preset veryfast -pix_fmt yuv420p -c:a aac -b:a 96k -movflags +faststart "media/reel-$n.mp4"
  # thumbnail from 1 second in
  ffmpeg -y -loglevel error -ss 1 -i "media/reel-$n.mp4" -frames:v 1 -q:v 3 "media/reel-$n.jpg"
  rm -f media/raw-$n.*
  i=$((i+1))
done
echo "Done. media/reel-01..09 .mp4 and .jpg are ready; open index.html."
