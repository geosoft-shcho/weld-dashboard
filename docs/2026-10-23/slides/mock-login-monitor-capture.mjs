/**
 * 로그인 · 수집 모니터링 HTML 목업 → 캡처 → 번호 배지.
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

const baseCss = `
  * { box-sizing: border-box; }
  body {
    margin: 0; width: 1440px; height: 900px;
    font-family: "Segoe UI", Arial, sans-serif;
    background: #1a1d21; color: #e8eaed;
  }
  .btn {
    background: #3a3f46; border: 1px solid #4a5058; color: #e8eaed;
    padding: 6px 12px; border-radius: 4px; font-size: 12px; cursor: default;
  }
  .btn.primary { background: #5b8def; border-color: #5b8def; color: #fff; }
  .label { font-size: 12px; color: #c5cad1; margin-bottom: 4px; }
  .input {
    width: 100%; background: #1f2227; border: 1px solid #3e424a;
    border-radius: 4px; color: #e8eaed; padding: 8px 10px; font-size: 13px;
  }
`;

function loginHtml() {
  return `<!DOCTYPE html>
<html lang="ko">
<head><meta charset="utf-8"/><style>
${baseCss}
  .wrap {
    height: 100%; display: flex; align-items: center; justify-content: center;
  }
  .card {
    width: 380px; padding: 28px 24px;
    background: #23262b; border: 1px solid #3e424a; border-radius: 6px;
  }
  .app-title {
    text-align: center; font-size: 20px; font-weight: 600; margin-bottom: 28px;
  }
  .field { margin-bottom: 14px; }
  .actions { margin-top: 20px; }
  .actions .btn.primary { width: 100%; padding: 10px; font-size: 14px; }
  .hint { margin-top: 14px; font-size: 11px; color: #9aa3ad; line-height: 1.4; }
</style></head>
<body>
  <div class="wrap">
    <div class="card" id="login-card">
      <div class="app-title" data-m="1">용접 수집 대시보드</div>
      <div class="field" data-m="2">
        <div class="label">ID</div>
        <input class="input" value="user"/>
      </div>
      <div class="field" data-m="3">
        <div class="label">Password</div>
        <input class="input" type="password" value="••••"/>
      </div>
      <div class="actions" data-m="4">
        <button class="btn primary">로그인</button>
      </div>
      <div class="hint">게스트(제한) 계정 ID는 user 입니다. 비밀번호는 별도 안내를 따릅니다.</div>
    </div>
  </div>
</body>
</html>`;
}

function monitoringHtml() {
  return `<!DOCTYPE html>
<html lang="ko">
<head><meta charset="utf-8"/><style>
${baseCss}
  .shell { display: flex; height: 900px; }
  .pane {
    width: 200px; background: #14171a; border-right: 1px solid #2e3238;
    padding: 16px 12px; flex-shrink: 0;
  }
  .pane .brand { font-size: 13px; font-weight: 600; margin-bottom: 18px; color: #c5cad1; }
  .pane .item {
    padding: 8px 10px; border-radius: 4px; font-size: 13px; margin-bottom: 4px; color: #aeb4bc;
  }
  .pane .item.active { background: #2a3340; color: #e8eaed; font-weight: 600; }
  .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
  .titlebar {
    height: 44px; border-bottom: 1px solid #2e3238; display: flex; align-items: center;
    padding: 0 16px; font-size: 14px; font-weight: 600;
  }
  .content { padding: 12px 16px; flex: 1; display: flex; flex-direction: column; gap: 12px; }
  .cmd {
    background: #23262b; border: 1px solid #3e424a; border-radius: 4px; padding: 10px 12px;
  }
  .cmd-row { display: flex; flex-wrap: wrap; gap: 10px; align-items: flex-end; }
  .f { width: 118px; }
  .f.wide { width: 150px; }
  .f .box {
    background: #1f2227; border: 1px solid #3e424a; border-radius: 4px;
    padding: 6px 8px; font-size: 12px; color: #e8eaed; height: 30px;
  }
  .actions { display: flex; gap: 8px; margin-left: auto; }
  .kpi {
    display: flex; gap: 10px;
  }
  .kpi .card {
    flex: 1; background: #23262b; border: 1px solid #3e424a; border-radius: 4px;
    padding: 10px 12px; font-size: 12px; color: #aeb4bc;
  }
  .kpi .v { font-size: 18px; font-weight: 700; color: #e8eaed; margin-top: 4px; }
  .tab {
    border-bottom: 1px solid #3e424a; padding-bottom: 0; margin-top: 2px;
  }
  .tab span {
    display: inline-block; padding: 8px 12px; font-size: 13px; font-weight: 600;
    border-bottom: 2px solid #5b8def; color: #e8eaed;
  }
  .timeline-host {
    flex: 1; background: #23262b; border: 1px solid #3e424a; border-radius: 4px;
    padding: 10px; display: flex; flex-direction: column; min-height: 0;
  }
  .views { display: flex; gap: 8px; margin-bottom: 10px; }
  .views .chip {
    background: #2a2d32; border: 1px solid #3e424a; border-radius: 4px;
    padding: 4px 10px; font-size: 12px; color: #c5cad1;
  }
  .views .chip.on { background: #2a3340; border-color: #5b8def; color: #e8eaed; }
  .tl {
    flex: 1; position: relative; background: #1a1d21; border-radius: 4px;
    overflow: hidden; padding: 8px 8px 8px 120px;
  }
  .hours {
    display: flex; justify-content: space-between; font-size: 10px; color: #7a828c;
    margin-bottom: 8px; padding-left: 0;
  }
  .row { display: flex; align-items: center; height: 36px; margin-bottom: 8px; position: relative; }
  .row .name {
    position: absolute; left: -112px; width: 100px; font-size: 11px; color: #c5cad1;
    text-align: right; padding-right: 8px;
  }
  .bar {
    position: absolute; height: 22px; border-radius: 3px; top: 7px;
  }
  .bar.a { background: #3d9a6a; left: 8%; width: 18%; }
  .bar.b { background: #5b8def; left: 32%; width: 22%; }
  .bar.c { background: #e8a838; left: 58%; width: 14%; }
  .bar.d { background: #3d9a6a; left: 18%; width: 28%; }
  .bar.e { background: #5b8def; left: 50%; width: 20%; }
</style></head>
<body>
  <div class="shell">
    <div class="pane">
      <div class="brand">용접 수집 대시보드</div>
      <div class="item active" data-m="1">수집 모니터링</div>
      <div class="item">작업 관리</div>
      <div class="item">공사 관리</div>
      <div class="item">에셋 관리</div>
    </div>
    <div class="main">
      <div class="titlebar">수집 모니터링</div>
      <div class="content">
        <div class="cmd" data-m="2">
          <div class="cmd-row">
            <div class="f wide"><div class="label">일자</div><div class="box">2026-10-27</div></div>
            <div class="f"><div class="label">시작</div><div class="box">08:00</div></div>
            <div class="f"><div class="label">종료</div><div class="box">18:00</div></div>
            <div class="f"><div class="label">보기</div><div class="box">리소스</div></div>
            <div class="f"><div class="label">장비</div><div class="box">전체</div></div>
            <div class="f"><div class="label">작업</div><div class="box">전체</div></div>
            <div class="f"><div class="label">새로고침 주기</div><div class="box">끔</div></div>
            <div class="actions" data-m="3">
              <button class="btn primary">조회</button>
              <button class="btn">초기화</button>
              <button class="btn">새로고침</button>
            </div>
          </div>
        </div>
        <div class="kpi">
          <div class="card">수집 중<div class="v">12</div></div>
          <div class="card">대기<div class="v">3</div></div>
          <div class="card">완료<div class="v">48</div></div>
          <div class="card">이상<div class="v">1</div></div>
        </div>
        <div class="tab"><span data-m="4">일자별 수집 타임라인</span></div>
        <div class="timeline-host" data-m="5">
          <div class="views" data-m="6">
            <span class="chip on">리소스</span>
            <span class="chip">하루 타임라인</span>
            <span class="chip">로드맵</span>
          </div>
          <div class="tl">
            <div class="hours"><span>08</span><span>10</span><span>12</span><span>14</span><span>16</span><span>18</span></div>
            <div class="row"><span class="name">용접기 A1</span><div class="bar a"></div><div class="bar b"></div></div>
            <div class="row"><span class="name">용접기 B2</span><div class="bar c"></div><div class="bar d"></div></div>
            <div class="row"><span class="name">용접기 C3</span><div class="bar e"></div></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>`;
}

async function captureWithColumnBadges(page, html, rawName, outName, anchorSelector) {
  const htmlPath = path.join(OUT, `_mock-${rawName}.html`);
  fs.writeFileSync(htmlPath, html, 'utf8');
  await page.goto(`file://${htmlPath}`, { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(200);
  const raw = path.join(OUT, rawName);
  await page.screenshot({ path: raw, fullPage: false });
  const markers = await page.evaluate(({ anchorSelector, step }) => {
    const els = [...document.querySelectorAll('[data-m]')].sort(
      (a, b) =>
        Number(a.getAttribute('data-m')) - Number(b.getAttribute('data-m')),
    );
    const anchor = document.querySelector(anchorSelector);
    const a = anchor?.getBoundingClientRect();
    const leftX = a ? a.left + 18 : 24;
    const first = els[0]?.getBoundingClientRect();
    const y0 = first ? first.top + Math.min(16, first.height * 0.4) : 80;
    return els.map((el, i) => ({
      n: Number(el.getAttribute('data-m')),
      x: leftX,
      y: y0 + i * step,
    }));
  }, { anchorSelector, step: 48 });
  await annotate(raw, markers, outName);
  try {
    fs.unlinkSync(htmlPath);
  } catch (_) {}
}

async function captureNearElements(page, html, rawName, outName) {
  const htmlPath = path.join(OUT, `_mock-${rawName}.html`);
  fs.writeFileSync(htmlPath, html, 'utf8');
  await page.goto(`file://${htmlPath}`, { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(200);
  const raw = path.join(OUT, rawName);
  await page.screenshot({ path: raw, fullPage: false });
  const markers = await page.evaluate(() => {
    return [...document.querySelectorAll('[data-m]')]
      .map((el) => {
        const r = el.getBoundingClientRect();
        return {
          n: Number(el.getAttribute('data-m')),
          x: Math.max(22, r.left + 14),
          y: r.top + Math.min(18, r.height * 0.4),
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
  await captureWithColumnBadges(
    page,
    loginHtml(),
    '_raw-login.png',
    '00-login-n.png',
    '#login-card',
  );
  await captureWithColumnBadges(
    page,
    monitoringHtml(),
    '_raw-collection-monitoring.png',
    '00-collection-monitoring-n.png',
    '.pane',
  );
} finally {
  await browser.close();
  console.log('mock-login-monitor-capture done');
}
