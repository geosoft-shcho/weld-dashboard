/**
 * _raw-*.png 에 번호 배지를 다시 올린다. 배지끼리 최소 간격 유지.
 * 업로드 3장은 mock-upload-capture.mjs 가 담당.
 */
import { createRequire } from 'module';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const OUT = path.join(__dirname, 'imgs');
const MIN_DIST = 46; // 반지름 18×2 + 여유
const R = 18;

function badgeSvg(n) {
  return Buffer.from(`<svg width="${R * 2}" height="${R * 2}" xmlns="http://www.w3.org/2000/svg">
  <circle cx="${R}" cy="${R}" r="${R - 1}" fill="#E76F51" stroke="#FFFFFF" stroke-width="2"/>
  <text x="${R}" y="${R + 1}" text-anchor="middle" dominant-baseline="central" font-family="Arial,sans-serif" font-size="18" font-weight="700" fill="#FFFFFF">${n}</text>
</svg>`);
}

/** 중심 거리가 MIN_DIST 미만이면 y(우선)·x로 밀어 낸다. */
function spread(markers) {
  const list = markers.map((m) => ({ ...m }));
  list.sort((a, b) => a.n - b.n);
  for (let i = 0; i < list.length; i++) {
    for (let j = 0; j < i; j++) {
      const a = list[i];
      const b = list[j];
      let dx = a.x - b.x;
      let dy = a.y - b.y;
      let dist = Math.hypot(dx, dy);
      if (dist >= MIN_DIST) continue;
      if (dist < 1) {
        dx = 0;
        dy = 1;
        dist = 1;
      }
      const push = (MIN_DIST - dist) / 2 + 1;
      const ux = dx / dist;
      const uy = dy / dist;
      a.x += ux * push;
      a.y += uy * push;
      b.x -= ux * push;
      b.y -= uy * push;
    }
  }
  for (const m of list) {
    m.x = Math.max(R + 2, Math.min(1440 - R - 2, m.x));
    m.y = Math.max(R + 2, Math.min(900 - R - 2, m.y));
  }
  // 한 번 더 밀어 클램프 후 재겹침 방지
  for (let pass = 0; pass < 4; pass++) {
    for (let i = 0; i < list.length; i++) {
      for (let j = 0; j < i; j++) {
        const a = list[i];
        const b = list[j];
        let dx = a.x - b.x;
        let dy = a.y - b.y;
        let dist = Math.hypot(dx, dy);
        if (dist >= MIN_DIST) continue;
        if (dist < 1) {
          dx = 0;
          dy = 1;
          dist = 1;
        }
        const push = (MIN_DIST - dist) / 2 + 1;
        a.x = Math.max(R + 2, Math.min(1440 - R - 2, a.x + (dx / dist) * push));
        a.y = Math.max(R + 2, Math.min(900 - R - 2, a.y + (dy / dist) * push));
        b.x = Math.max(R + 2, Math.min(1440 - R - 2, b.x - (dx / dist) * push));
        b.y = Math.max(R + 2, Math.min(900 - R - 2, b.y - (dy / dist) * push));
      }
    }
  }
  return list;
}

async function annotate(rawName, outName, markers) {
  const raw = path.join(OUT, rawName);
  if (!fs.existsSync(raw)) {
    console.warn('skip missing', rawName);
    return;
  }
  const fixed = spread(markers);
  const composites = fixed.map((m) => ({
    input: badgeSvg(m.n),
    left: Math.round(m.x - R),
    top: Math.round(m.y - R),
  }));
  await sharp(raw).composite(composites).png().toFile(path.join(OUT, outName));
  const overlaps = [];
  for (let i = 0; i < fixed.length; i++) {
    for (let j = i + 1; j < fixed.length; j++) {
      const d = Math.hypot(fixed[i].x - fixed[j].x, fixed[i].y - fixed[j].y);
      if (d < MIN_DIST - 0.5) overlaps.push(`${fixed[i].n}-${fixed[j].n}:${d.toFixed(1)}`);
    }
  }
  console.log(
    'wrote',
    outName,
    fixed.map((m) => `${m.n}@${Math.round(m.x)},${Math.round(m.y)}`).join(' '),
    overlaps.length ? `OVERLAP ${overlaps.join(' ')}` : 'ok',
  );
}

// 좌표는 1440×900, 컨트롤 왼쪽/위에 두어 글자·배지 겹침을 줄인다.
const jobs = [
  [
    '_raw-history.png',
    '01-work-history-n.png',
    [
      { n: 1, x: 28, y: 120 },
      { n: 2, x: 980, y: 118 },
      { n: 3, x: 1280, y: 118 },
      { n: 4, x: 1120, y: 320 },
      { n: 5, x: 1220, y: 320 },
      { n: 6, x: 1340, y: 320 },
    ],
  ],
  [
    '_raw-newjob.png',
    '02-new-job-dialog-n.png',
    [
      { n: 1, x: 430, y: 210 },
      { n: 2, x: 430, y: 270 },
      { n: 3, x: 430, y: 340 },
      { n: 4, x: 430, y: 400 },
      { n: 5, x: 430, y: 470 },
      { n: 6, x: 430, y: 560 },
      { n: 7, x: 980, y: 780 },
    ],
  ],
  [
    '_raw-history.png',
    '06-list-actions-n.png',
    [
      { n: 1, x: 1120, y: 320 },
      { n: 2, x: 1220, y: 320 },
      { n: 3, x: 1340, y: 320 },
    ],
  ],
  [
    '_raw-info.png',
    '04-job-detail-info-n.png',
    [
      { n: 1, x: 80, y: 130 },
      { n: 2, x: 120, y: 220 },
      { n: 3, x: 1180, y: 220 },
      { n: 4, x: 1320, y: 220 },
      { n: 5, x: 100, y: 360 },
      { n: 6, x: 1280, y: 70 },
    ],
  ],
  [
    '_raw-pass.png',
    '05-job-detail-pass-n.png',
    [
      { n: 1, x: 1280, y: 250 },
      { n: 2, x: 120, y: 340 },
      { n: 3, x: 1360, y: 340 },
      { n: 4, x: 200, y: 520 },
    ],
  ],
  [
    '_raw-pass-add.png',
    '08-pass-add-n.png',
    [
      { n: 1, x: 480, y: 280 },
      { n: 2, x: 480, y: 350 },
      { n: 3, x: 480, y: 420 },
      { n: 4, x: 480, y: 490 },
      { n: 5, x: 480, y: 560 },
      { n: 6, x: 980, y: 700 },
    ],
  ],
  [
    '_raw-attach.png',
    '06-job-detail-attach-n.png',
    [
      { n: 1, x: 1180, y: 250 },
      { n: 2, x: 1320, y: 250 },
      { n: 3, x: 1100, y: 420 },
      { n: 4, x: 1360, y: 420 },
    ],
  ],
  [
    '_raw-profile.png',
    '08-pass-profile-n.png',
    [
      { n: 1, x: 80, y: 120 },
      { n: 2, x: 80, y: 280 },
      { n: 3, x: 200, y: 420 },
    ],
  ],
  [
    '_raw-quality.png',
    '09-quality-issue-n.png',
    [
      { n: 1, x: 80, y: 280 },
      { n: 2, x: 420, y: 480 },
      { n: 3, x: 900, y: 480 },
    ],
  ],
];

for (const [raw, out, markers] of jobs) {
  await annotate(raw, out, markers);
}
console.log('reannotate-manual-badges done');
