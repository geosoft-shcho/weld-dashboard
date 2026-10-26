/**
 * 현재 에셋 올리기 다이얼로그 레이아웃 HTML 목업 → 캡처 → 번호 배지.
 * (헤드리스에서 Flutter 캔버스가 비어 있어 목업으로 대체)
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

function badgeSvg(n, r = 18) {
  return Buffer.from(`<svg width="${r * 2}" height="${r * 2}" xmlns="http://www.w3.org/2000/svg">
  <circle cx="${r}" cy="${r}" r="${r - 1}" fill="#E76F51" stroke="#FFFFFF" stroke-width="2"/>
  <text x="${r}" y="${r + 1}" text-anchor="middle" dominant-baseline="central" font-family="Arial,sans-serif" font-size="18" font-weight="700" fill="#FFFFFF">${n}</text>
</svg>`);
}

async function annotate(pngPath, markers, outName) {
  const composites = markers.map((m) => {
    const r = 18;
    return {
      input: badgeSvg(m.n, r),
      left: Math.max(0, Math.round(m.x - r)),
      top: Math.max(0, Math.round(m.y - r)),
    };
  });
  const out = path.join(OUT, outName);
  await sharp(pngPath).composite(composites).png().toFile(out);
  console.log('wrote', outName);
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
    width: 560px; max-height: 820px; overflow: auto;
    background: #2a2d32; border: 1px solid #3e424a; border-radius: 6px;
    box-shadow: 0 12px 40px rgba(0,0,0,0.45); padding: 16px 18px 14px;
  }
  .dialog h2 { margin: 0 0 14px; font-size: 18px; font-weight: 600; }
  .field { margin-bottom: 12px; }
  .label { font-size: 12px; color: #c5cad1; margin-bottom: 4px; }
  .row { display: flex; gap: 12px; }
  .row > .field { flex: 1; }
  .btn {
    background: #3a3f46; border: 1px solid #4a5058; color: #e8eaed;
    padding: 7px 12px; border-radius: 4px; font-size: 13px; cursor: default;
  }
  .btn.primary { background: #5b8def; border-color: #5b8def; color: #fff; }
  .input, .select, .area {
    width: 100%; background: #1f2227; border: 1px solid #3e424a;
    border-radius: 4px; color: #e8eaed; padding: 8px 10px; font-size: 13px;
  }
  .area { min-height: 56px; resize: none; }
  .hint { font-size: 12px; color: #9aa3ad; margin-top: 4px; line-height: 1.4; }
  .actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
  .chips { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
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

function dialogGeneral() {
  return `
  <h2>에셋 올리기</h2>
  <div class="field" data-m="1">
    <div class="label">파일 *</div>
    <div style="display:flex;gap:8px;align-items:center">
      <button class="btn">파일 고르기</button>
      <span style="font-size:13px;color:#c5cad1">선택한 파일 없음</span>
    </div>
    <div class="hint">종류는 서버가 내용으로 정합니다. 표시는 확장자로 짐작한 안내입니다.</div>
  </div>
  <div class="field" data-m="2">
    <div class="label">주제</div>
    <textarea class="area" placeholder="주제"></textarea>
  </div>
  <div class="field" data-m="3">
    <div class="label">상황</div>
    <textarea class="area" placeholder="상황"></textarea>
  </div>
  <div class="row">
    <div class="field" data-m="4">
      <div class="label">작업</div>
      <div class="select">EX006_01-LD-C</div>
    </div>
    <div class="field" data-m="5">
      <div class="label">패스</div>
      <div class="select">작업 공용</div>
    </div>
  </div>
  <div class="row">
    <div class="field" data-m="6">
      <div class="label">장비</div>
      <div class="select">모름</div>
    </div>
    <div class="field" data-m="7">
      <div class="label">시간 0의 시각</div>
      <input class="input" value="2026-09-16 13:38:53"/>
    </div>
  </div>
  <div class="hint">영상은 첫 프레임, IMU는 깊이 녹화 시작, 회전수는 구간 시작</div>
  <div class="actions">
    <button class="btn">취소</button>
    <button class="btn primary" data-m="8">올리기</button>
  </div>`;
}

function dialogVideo() {
  return `
  <h2>에셋 올리기</h2>
  <div class="field">
    <div class="label">파일 *</div>
    <div style="display:flex;gap:8px;align-items:center">
      <button class="btn">파일 고르기</button>
      <span style="font-size:13px">sample.mp4</span>
    </div>
    <div class="hint" data-m="1">영상 — 서버가 내용으로 최종 판별합니다</div>
    <div class="hint" data-m="2">올린 뒤 후처리: 파일 속성 → 길이 → 타임라인 배치</div>
  </div>
  <div class="field">
    <div class="label">주제</div>
    <textarea class="area" placeholder="주제"></textarea>
  </div>
  <div class="field">
    <div class="label">상황</div>
    <textarea class="area" placeholder="상황"></textarea>
  </div>
  <div class="row">
    <div class="field"><div class="label">작업</div><div class="select">EX006_01-LD-C</div></div>
    <div class="field"><div class="label">패스</div><div class="select">작업 공용</div></div>
  </div>
  <div class="row">
    <div class="field"><div class="label">장비</div><div class="select">모름</div></div>
    <div class="field" data-m="3">
      <div class="label">시간 0의 시각 *</div>
      <input class="input" value="2026-09-16 13:38:53"/>
    </div>
  </div>
  <div class="hint">영상은 첫 프레임, IMU는 깊이 녹화 시작, 회전수는 구간 시작</div>
  <div class="chips" data-m="4">
    <button class="btn">작업 시작 2026-09-30 08:16:00</button>
    <button class="btn">파일 시각 2026-10-23 11:21:37</button>
    <button class="btn">현재 시각</button>
  </div>
  <div class="actions">
    <button class="btn">취소</button>
    <button class="btn primary">올리기</button>
  </div>`;
}

function dialogPdf() {
  return `
  <h2>에셋 올리기</h2>
  <div class="field">
    <div class="label">파일 *</div>
    <div style="display:flex;gap:8px;align-items:center">
      <button class="btn">파일 고르기</button>
      <span style="font-size:13px">sample.pdf</span>
    </div>
    <div class="hint" data-m="1">문서 · 성적서 — 서버가 내용으로 최종 판별합니다</div>
    <div class="hint" data-m="2">올린 뒤 후처리: 파일 속성 → 글자 인식 · 성적서</div>
  </div>
  <div class="field">
    <div class="label">주제</div>
    <textarea class="area" placeholder="주제"></textarea>
  </div>
  <div class="field">
    <div class="label">상황</div>
    <textarea class="area" placeholder="상황"></textarea>
  </div>
  <div class="row">
    <div class="field"><div class="label">작업</div><div class="select">EX006_01-LD-C</div></div>
    <div class="field"><div class="label">패스</div><div class="select">작업 공용</div></div>
  </div>
  <div class="row">
    <div class="field"><div class="label">장비</div><div class="select">모름</div></div>
    <div class="field" data-m="3">
      <div class="label">시간 0의 시각</div>
      <input class="input" value="2026-09-16 13:38:53"/>
    </div>
  </div>
  <div class="hint">영상은 첫 프레임, IMU는 깊이 녹화 시작, 회전수는 구간 시작</div>
  <div class="actions">
    <button class="btn">취소</button>
    <button class="btn primary">올리기</button>
  </div>`;
}

async function captureVariant(page, html, rawName, outName) {
  const htmlPath = path.join(OUT, `_mock-${rawName}.html`);
  fs.writeFileSync(htmlPath, html, 'utf8');
  await page.goto(`file://${htmlPath}`, { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(200);
  const raw = path.join(OUT, rawName);
  await page.screenshot({ path: raw, fullPage: false });
  const markers = await page.evaluate(() => {
    return [...document.querySelectorAll('[data-m]')].map((el) => {
      const r = el.getBoundingClientRect();
      return {
        n: Number(el.getAttribute('data-m')),
        x: r.left + Math.min(22, r.width * 0.08),
        y: r.top + Math.min(14, r.height * 0.35),
      };
    });
  });
  await annotate(raw, markers, outName);
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
