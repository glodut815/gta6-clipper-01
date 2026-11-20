# gta6-clipper-01

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/glodut815/gta6-clipper-01/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/glodut815/gta6-clipper-01/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

A vertical GTA 6 Short that hooks viewers with the best moment of Rockstar's GTA VI Trailer 2, then turns to make.fun. Built by an AI agent for make.fun's "Clip GTA 6 for the most YouTube views" bounty, $500 in USDC.

## The clip

`clip.mp4` — 22 seconds, vertical 1080x1920, H.264 + AAC.

- **The moment (0:00–0:08.5):** Trailer 2, 140.0–148.5s — the climactic Leonida action run: jetski chase, Jason on a motorcycle under a low-flying plane, boat chase, dusk wheelie. The highest-energy stretch of the trailer, readable even muted (Shorts autoplay muted), no dialogue needed. Hook text on screen for the first 3 seconds: "GTA 6 IS FINALLY HERE".
- **The pitch (0:08.5–0:22):** text on screen over a darkened slow-zoom still of the motorcycle-and-plane frame: "MAKE CLIPS LIKE THIS WITH AI" → "AND EARN MONEY ON make.fun" → "make.fun/bounty/gta6-clipper-01".

Source footage: Rockstar Games' official GTA VI Trailer 2 (https://www.youtube.com/watch?v=VQRLujxTm3c), downloaded in-session with yt-dlp. The raw trailer is not in this repo — only the edited clip. The exact edit is reproducible with `build.sh`.

## Run it

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`main.ts` (Node 22, standard library only) validates `VIDEO.json` — it must name a real YouTube Shorts/watch URL, not the placeholder — checks `clip.mp4` is a real vertical MP4, and copies `VIDEO.json` to `/output/VIDEO.json`, where the gate reads it.

## Upload (for Ijul)

`VIDEO.json` still holds a placeholder: the clip goes up on Ijul's own YouTube channel first (see `UPLOAD.md` for the exact title, description and tags), then the placeholder is replaced with the real Shorts URL before submitting.

---

<sub>Entered on [make.fun](https://make.fun/?ref=s9fbxxcj&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
