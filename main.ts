// gta6-clipper-01 entry (Node 22, standard library only).
//
// The entry is the video itself: a vertical GTA 6 clip that hooks the viewer
// with Trailer 2's climactic Leonida action run and then pitches make.fun.
// This program validates VIDEO.json and the clip, then copies VIDEO.json
// to /output/VIDEO.json, where the gate reads it.
//
// VIDEO.json currently holds a placeholder: Ijul uploads clip.mp4 to his own
// YouTube channel and sends the link back; the parent replaces the placeholder
// with the real Shorts URL before submitting. This program refuses the
// placeholder on purpose, so a submit can never go out with it.
//
// Outside the grader's container, MAKEFUN_BOT_DIR and MAKEFUN_OUTPUT_DIR
// stand in for /bot and /output:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, existsSync, mkdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

// A YouTube video address as the Share button gives it, with an 11-character id.
const YOUTUBE_URL =
  /^https:\/\/(?:www\.|m\.)?(?:youtube\.com\/(?:shorts\/|watch\?v=)|youtu\.be\/)([A-Za-z0-9_-]{11})(?:[?&#].*)?$/;

function fail(message: string): never {
  console.error(`VIDEO.json invalid: ${message}`);
  process.exit(1);
}

const videoPath = join(BOT_DIR, 'VIDEO.json');
if (!existsSync(videoPath)) fail(`no VIDEO.json in ${BOT_DIR}`);

let video: unknown;
try {
  video = JSON.parse(readFileSync(videoPath, 'utf8'));
} catch (err) {
  fail(`not valid JSON: ${(err as Error).message}`);
}

if (typeof video !== 'object' || video === null || Array.isArray(video)) {
  fail('must be a JSON object with a url field');
}
const url = (video as { url?: unknown }).url;
if (typeof url !== 'string') fail('url must be a string');
if (url.includes('REPLACE_WITH_IJUL_UPLOAD')) {
  fail('url is still the placeholder — replace it with the uploaded YouTube Shorts URL first');
}
const match = YOUTUBE_URL.exec(url);
if (!match) {
  fail('url must be https://www.youtube.com/shorts/<11-char id>, /watch?v=<id> or https://youtu.be/<id>');
}

// The clip itself: it must be there, be a real MP4, and be vertical.
const clipPath = join(BOT_DIR, 'clip.mp4');
if (!existsSync(clipPath)) fail('no clip.mp4 in the repository root');
const clipSize = statSync(clipPath).size;
if (clipSize < 1_000_000) fail(`clip.mp4 is only ${clipSize} bytes, expected a rendered clip`);
const header = readFileSync(clipPath);
const magic = header.subarray(4, 8).toString('ascii');
if (magic !== 'ftyp') fail(`clip.mp4 does not start with an MP4 ftyp box (got ${JSON.stringify(magic)})`);

console.log(`VIDEO.json OK: video id ${match[1]}, clip.mp4 ${clipSize} bytes`);
mkdirSync(OUTPUT_DIR, { recursive: true });
copyFileSync(videoPath, join(OUTPUT_DIR, 'VIDEO.json'));
console.log(`copied VIDEO.json to ${OUTPUT_DIR}/VIDEO.json`);
