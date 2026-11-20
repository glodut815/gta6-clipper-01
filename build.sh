#!/bin/bash
# Rebuild clip.mp4 from Rockstar's official GTA VI Trailer 2.
#
# 1. Fetch the source (run once, in-session — the raw trailer is NOT committed):
#      yt-dlp --extractor-args "youtube:player_client=tv_embedded" \
#        -f "137+140" --merge-output-format mp4 \
#        -o /tmp/clipper/gta6-trailer2-1080p.mp4 \
#        "https://www.youtube.com/watch?v=VQRLujxTm3c"
#    (Rockstar Games, GTA VI Trailer 2, 1080p, 166.8s.)
#
# 2. This script cuts the moment and renders the clip:
#    Moment: trailer 140.0-148.5s — the climactic Leonida action run
#    (jetski chase -> motorcycle under a low plane -> boat chase -> dusk
#    wheelie), vertical center-crop, hook text "GTA 6 IS FINALLY HERE"
#    for the first 3 seconds; then 13.5s of make.fun pitch as text over a
#    darkened slow-zoom still of the motorcycle+plane frame (the still is
#    fed once; zoompan d=405 expands it to 13.5s at 30fps — do NOT loop
#    the still, or zoompan multiplies the frames).
#    Output: 22.0s, vertical 1080x1920, H.264 + AAC.
set -euo pipefail
SRC="${TRAILER:-/tmp/clipper/gta6-trailer2-1080p.mp4}"
OUT="$(dirname "$0")/clip.mp4"
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

ffmpeg -y -v error \
  -i "$SRC" \
  -framerate 30 -i /tmp/clipper/frame143.jpg \
  -filter_complex "\
[0:v]trim=140.0:148.5,setpts=PTS-STARTPTS,crop=607:1080:656:0,scale=1080:1920:flags=lanczos,setsar=1,unsharp=5:5:0.5,\
drawtext=fontfile=$FONT:text='GTA 6 IS':fontcolor=white:fontsize=110:borderw=3:bordercolor=black:x=(w-text_w)/2:y=760:enable='between(t,0,3)',\
drawtext=fontfile=$FONT:text='FINALLY HERE':fontcolor=white:fontsize=110:borderw=3:bordercolor=black:x=(w-text_w)/2:y=890:enable='between(t,0,3)'[vA];\
[0:a]atrim=140.0:148.5,asetpts=PTS-STARTPTS,afade=t=out:st=7:d=1.5[aA];\
[1:v]scale=1080:1920:flags=lanczos,zoompan=z='min(zoom+0.0006\,1.12)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=405:s=1080x1920:fps=30,setsar=1,eq=brightness=-0.38:saturation=0.85,format=yuv420p,\
drawtext=fontfile=$FONT:text='MAKE CLIPS LIKE':fontcolor=white:fontsize=92:borderw=3:bordercolor=black:x=(w-text_w)/2:y=700:enable='between(t,0,4.49)',\
drawtext=fontfile=$FONT:text='THIS WITH AI':fontcolor=white:fontsize=92:borderw=3:bordercolor=black:x=(w-text_w)/2:y=810:enable='between(t,0,4.49)',\
drawtext=fontfile=$FONT:text='AND EARN MONEY':fontcolor=white:fontsize=92:borderw=3:bordercolor=black:x=(w-text_w)/2:y=700:enable='between(t,4.5,8.99)',\
drawtext=fontfile=$FONT:text='ON make.fun':fontcolor=white:fontsize=92:borderw=3:bordercolor=black:x=(w-text_w)/2:y=810:enable='between(t,4.5,8.99)',\
drawtext=fontfile=$FONT:text='make.fun/bounty':fontcolor=white:fontsize=72:borderw=3:bordercolor=black:x=(w-text_w)/2:y=760:enable='between(t,9,13.5)',\
drawtext=fontfile=$FONT:text='gta6-clipper-01':fontcolor=white:fontsize=72:borderw=3:bordercolor=black:x=(w-text_w)/2:y=850:enable='between(t,9,13.5)'[vB];\
anullsrc=channel_layout=stereo:sample_rate=48000,atrim=0:13.5,asetpts=PTS-STARTPTS[aB];\
[vA][aA][vB][aB]concat=n=2:v=1:a=1[v][a]" \
  -map "[v]" -map "[a]" -c:v libx264 -preset medium -crf 19 -pix_fmt yuv420p \
  -c:a aac -b:a 128k -movflags +faststart -r 30 "$OUT"

ffprobe -v error -show_entries format=duration,size \
  -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 "$OUT"
