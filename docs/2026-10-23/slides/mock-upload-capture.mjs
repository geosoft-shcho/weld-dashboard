/**
 * 다건 에셋 올리기 다이얼로그 HTML 목업 → 캡처 → 번호 배지.
 * (헤드리스 Flutter 캔버스가 비어 목업으로 대체. UI는 asset_upload_dialog.dart 기준)
 */
import { chromium } from 'playwright';
import { createRequire } from 'module';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const OUT = path.join(__dirname, 'imgs');
const VIEW = { width: 1440, height: 900 };

const R = 18;
const MIN_DIST = 46;

function badgeSvg(n) {
  return Buffer.from(`<svg width="${R * 2}" height="${R * 2}" xmlns="http://www.w3.org/2000/svg">
  <circle cx="${R}" cy="${R}" r="${R - 1}" fill="#E76F51" stroke="#FFFFFF" stroke-width="2"/>
  <text x="${R}" y="${R + 1}" text-anchor="middle" dominant-baseline="central" font-family="Arial,sans-serif" font-size="18" font-weight="700" fill="#FFFFFF">${n}</text>
</svg>`);
}

function spreadMarkers(markers) {
  const list = markers.map((m) => ({ ...m }));
  list.sort((a, b) => a.n - b.n);
  for (let pass = 0; pass < 6; pass++) {
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
        a.x += (dx / dist) * push;
        a.y += (dy / dist) * push;
        b.x -= (dx / dist) * push;
        b.y -= (dy / dist) * push;
      }
    }
    for (const m of list) {
      m.x = Math.max(R + 2, Math.min(VIEW.width - R - 2, m.x));
      m.y = Math.max(R + 2, Math.min(VIEW.height - R - 2, m.y));
    }
  }
  return list;
}

async function annotate(pngPath, markers, outName) {
  const fixed = spreadMarkers(markers);
  const composites = fixed.map((m) => ({
    input: badgeSvg(m.n),
    left: Math.max(0, Math.round(m.x - R)),
    top: Math.max(0, Math.round(m.y - R)),
  }));
  const out = path.join(OUT, outName);
  await sharp(pngPath).composite(composites).png().toFile(out);
  console.log(
    'wrote',
    outName,
    fixed.map((m) => `${m.n}@${Math.round(m.x)},${Math.round(m.y)}`).join(' '),
  );
}

function shellHtml(dialogInner) {
  return `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<style>
  * { box-sizing: border-box; }
  body {
    margin: 0; width: 1440px; height: 900px;
    font-family: "Segoe UI", Arial, sans-serif;
    background: #1a1d21; color: #e8eaed;
  }
  .app { padding: 16px 20px; }
  .top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
  .title { font-size: 18px; font-weight: 600; }
  .nav button {
    background: #2a2d32; border: 1px solid #3e424a; color: #e8eaed;
    padding: 6px 12px; margin-left: 6px; border-radius: 4px; font-size: 13px;
  }
  .card {
    background: #23262b; border: 1px solid #3e424a; border-radius: 4px;
    padding: 12px; margin-bottom: 12px; font-size: 13px; color: #aeb4bc;
  }
  .table {
    background: #23262b; border: 1px solid #3e424a; border-radius: 4px;
    min-height: 420px; padding: 8px;
  }
  .table-head { display: flex; gap: 8px; margin-bottom: 8px; justify-content: flex-end; }
  .table-head button {
    background: #2a2d32; border: 1px solid #3e424a; color: #e8eaed;
    padding: 6px 12px; border-radius: 4px; font-size: 13px;
  }
  .backdrop {
    position: fixed; inset: 0; background: rgba(0,0,0,0.55);
    display: flex; align-items: center; justify-content: center;
  }
  .dialog {
    width: 680px; max-height: 860px; overflow: hidden;
    background: #2a2d32; border: 1px solid #3e424a; border-radius: 6px;
    box-shadow: 0 12px 40px rgba(0,0,0,0.45); padding: 12px 16px 10px 28px;
    position: relative;
  }
  .field, .queue-head, .file-card, .actions, .chips { position: relative; }
  .dialog h2 { margin: 0 0 10px; font-size: 17px; font-weight: 600; }
  .field { margin-bottom: 8px; }
  .label { font-size: 12px; color: #c5cad1; margin-bottom: 3px; }
  .row { display: flex; gap: 12px; }
  .row > .field { flex: 1; }
  .btn {
    background: #3a3f46; border: 1px solid #4a5058; color: #e8eaed;
    padding: 6px 10px; border-radius: 4px; font-size: 12px; cursor: default;
  }
  .btn.primary { background: #5b8def; border-color: #5b8def; color: #fff; }
  .input, .select, .area {
    width: 100%; background: #1f2227; border: 1px solid #3e424a;
    border-radius: 4px; color: #e8eaed; padding: 6px 8px; font-size: 12px;
  }
  .area { min-height: 32px; height: 32px; resize: none; }
  .hint { font-size: 11px; color: #9aa3ad; margin-top: 3px; line-height: 1.35; }
  .actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 10px; }
  .chips { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 6px; }
  .queue-head { display: flex; align-items: center; gap: 8px; margin: 6px 0; }
  .file-card {
    border: 1px solid #3e424a; border-radius: 4px; padding: 8px; margin-bottom: 6px;
  }
  .file-name { font-size: 13px; font-weight: 600; margin-bottom: 4px; }
  .warn { font-size: 12px; color: #e8a838; margin-top: 2px; }
  .status { font-size: 12px; margin-top: 6px; }
</style>
</head>
<body>
  <div class="app">
    <div class="top">
      <div class="title">용접 수집 대시보드 : 작업 상세 388</div>
      <div class="nav">
        <button>목록으로</button><button>비디오 멀티모달</button>
        <button>프로파일</button><button>품질 이슈</button>
      </div>
    </div>
    <div class="card">EX006_01-LD-C · DGT-ELC-01 · 첨부 탭</div>
    <div class="table">
      <div class="table-head">
        <button>에셋 올리기</button><button>에셋 붙이기</button>
      </div>
    </div>
  </div>
  <div class="backdrop">
    <div class="dialog" id="dialog">${dialogInner}</div>
  </div>
</body>
</html>`;
}

function commonTop({ mark = false, chips = true } = {}) {
  const m = (n) => (mark ? ` data-m="${n}"` : '');
  return `
  <div class="field"${m(1)}>
    <div class="label">주제</div>
    <textarea class="area" placeholder="주제(파일 공통 기본값)"></textarea>
  </div>
  <div class="field"${m(2)}>
    <div class="label">상황</div>
    <textarea class="area" placeholder="상황(파일 공통 기본값)"></textarea>
  </div>
  <div class="row">
    <div class="field"${m(3)}>
      <div class="label">작업</div>
      <div class="select">EX006_01-LD-C</div>
    </div>
    <div class="field"${m(4)}>
      <div class="label">패스</div>
      <div class="select">작업 공용</div>
    </div>
  </div>
  <div class="row">
    <div class="field"${m(5)}>
      <div class="label">장비</div>
      <div class="select">모름</div>
    </div>
    <div class="field"${m(6)}>
      <div class="label">시간 0의 시각(공통)</div>
      <input class="input" value="2026-09-16 13:38:53"/>
    </div>
  </div>
  <div class="hint">파일마다 시간 0을 따로 둘 수 있습니다. 액션캠·깊이 영상은 촬영 시각이 없을 수 있어 넣는 것이 좋습니다.</div>
  ${
    chips
      ? `<div class="chips">
    <button class="btn">공통 시각을 모든 파일에</button>
    <button class="btn">패스 시작 2026-09-30 08:16:00</button>
    <button class="btn">작업 시작 2026-09-30 08:16:00</button>
    <button class="btn">현재 시각</button>
  </div>`
      : ''
  }`;
}

function dialogGeneral() {
  return `
  <h2>에셋 올리기</h2>
  ${commonTop({ mark: true })}
  <div class="queue-head" data-m="7">
    <button class="btn">파일 고르기</button>
    <span style="font-size:12px">2개 파일</span>
  </div>
  <div class="hint" style="margin-bottom:8px">파일을 여러 개 고르면 대기열에 넣고, 동시에 최대 3개까지 올립니다. 큰 파일은 이어 올리기로 보냅니다.</div>
  <div class="file-card" data-m="8">
    <div class="file-name">sample.mp4</div>
    <div class="hint">영상 — 서버가 내용으로 최종 판별합니다 · 후처리: 파일 속성 → 길이 → 타임라인 배치</div>
    <div class="label" style="margin-top:6px">시간 0의 시각</div>
    <input class="input" value="2026-09-16 13:38:53"/>
  </div>
  <div class="file-card">
    <div class="file-name">sample.pdf</div>
    <div class="hint">문서 · 성적서 · 후처리: 파일 속성 → 글자 인식·성적서</div>
    <div class="label" style="margin-top:6px">시간 0의 시각</div>
    <input class="input" placeholder="비우면 서버 규칙(파일 시각·촬영 시각)"/>
  </div>
  <div class="actions">
    <button class="btn">취소</button>
    <button class="btn primary" data-m="9">올리기</button>
  </div>`;
}

function dialogVideo() {
  return `
  <h2>에셋 올리기</h2>
  ${commonTop({ mark: false, chips: false })}
  <div class="queue-head">
    <button class="btn">파일 고르기</button>
    <span style="font-size:12px">1개 파일</span>
  </div>
  <div class="file-card" id="file-card">
    <div class="file-name">sample.mp4</div>
    <div class="hint" data-m="1">영상 — 서버가 내용으로 최종 판별합니다</div>
    <div class="hint" data-m="2">후처리: 파일 속성 → 길이 → 타임라인 배치</div>
    <div class="label" style="margin-top:8px" data-m="3">시간 0의 시각</div>
    <input class="input" value="2026-09-16 13:38:53"/>
    <div class="hint">비우면 서버가 파일·촬영 시각을 씁니다. 액션캠·깊이는 넣는 것이 좋습니다.</div>
    <div class="status" data-m="5">업로드 중 42%</div>
    <div class="warn">작업 구간 밖이라 타임라인에 안 놓일 수 있습니다(첨부는 됨)</div>
  </div>
  <div class="chips" data-m="4">
    <button class="btn">공통 시각을 모든 파일에</button>
    <button class="btn">작업 시작 2026-09-30 08:16:00</button>
    <button class="btn">현재 시각</button>
  </div>
  <div class="actions">
    <button class="btn">취소</button>
    <button class="btn primary">올리는 중…</button>
  </div>`;
}

function dialogPdf() {
  return `
  <h2>에셋 올리기</h2>
  ${commonTop({ mark: false, chips: false })}
  <div class="queue-head">
    <button class="btn">파일 고르기</button>
    <span style="font-size:12px">1개 파일</span>
  </div>
  <div class="file-card" id="file-card">
    <div class="file-name">sample.pdf</div>
    <div class="hint" data-m="1">문서 · 성적서 — 서버가 내용으로 최종 판별합니다</div>
    <div class="hint" data-m="2">후처리: 파일 속성 → 글자 인식·성적서</div>
    <div class="label" style="margin-top:8px" data-m="3">시간 0의 시각</div>
    <input class="input" placeholder="비워도 됩니다"/>
    <div class="hint">선택 칸입니다. 비워도 올릴 수 있습니다.</div>
    <div class="status">완료 · 에셋 19690</div>
  </div>
  <div class="actions">
    <button class="btn">닫기</button>
    <button class="btn primary">완료</button>
  </div>`;
}

async function captureVariant(page, html, rawName, outName) {
  const htmlPath = path.join(OUT, `_mock-${rawName}.html`);
  fs.writeFileSync(htmlPath, html, 'utf8');
  await page.goto(`file://${htmlPath}`, { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(200);
  const raw = path.join(OUT, rawName);
  await page.screenshot({ path: raw, fullPage: false });
  // 배지: 각 data-m 요소 왼쪽 옆 (번호표와 1:1). spread로 겹침만 해소.
  const markers = await page.evaluate(() => {
    return [...document.querySelectorAll('[data-m]')]
      .map((el) => {
        const r = el.getBoundingClientRect();
        return {
          n: Number(el.getAttribute('data-m')),
          x: Math.max(22, r.left - 8),
          y: r.top + Math.min(18, Math.max(10, r.height * 0.4)),
        };
      })
      .sort((a, b) => a.n - b.n);
  });
  await annotate(raw, markers, outName);
  try {
    fs.unlinkSync(htmlPath);
  } catch (_) {}
}

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: VIEW });
try {
  await captureVariant(
    page,
    shellHtml(dialogGeneral()),
    '_raw-upload.png',
    '10-asset-upload-n.png',
  );
  await captureVariant(
    page,
    shellHtml(dialogVideo()),
    '_raw-upload-video.png',
    '11-upload-video-n.png',
  );
  await captureVariant(
    page,
    shellHtml(dialogPdf()),
    '_raw-upload-pdf.png',
    '11-upload-pdf-n.png',
  );
} finally {
  await browser.close();
  console.log('mock-upload-capture done');
}
