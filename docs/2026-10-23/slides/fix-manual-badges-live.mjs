/**
 * CDP로 실화면 캡처 후, 번호표와 맞는 위치에 배지를 붙인다.
 * FLUTTER_CDP / FLUTTER_APP_URL 환경변수 지원.
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
const CDP = process.env.FLUTTER_CDP || 'http://127.0.0.1:61017';
const APP = process.env.FLUTTER_APP_URL || 'http://localhost:60976';
const R = 18;
const MIN_DIST = 46;

function badgeSvg(n) {
  return Buffer.from(`<svg width="${R * 2}" height="${R * 2}" xmlns="http://www.w3.org/2000/svg">
  <circle cx="${R}" cy="${R}" r="${R - 1}" fill="#E76F51" stroke="#FFFFFF" stroke-width="2"/>
  <text x="${R}" y="${R + 1}" text-anchor="middle" dominant-baseline="central" font-family="Arial,sans-serif" font-size="18" font-weight="700" fill="#FFFFFF">${n}</text>
</svg>`);
}

function spread(markers) {
  const list = markers.map((m) => ({ ...m }));
  list.sort((a, b) => a.n - b.n);
  for (let pass = 0; pass < 8; pass++) {
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

async function coverDebugAndAnnotate(rawPath, markers, outName) {
  const overlay = Buffer.from(
    `<svg width="${VIEW.width}" height="${VIEW.height}"><rect x="${VIEW.width - 90}" y="0" width="90" height="90" fill="#1B1B1B"/></svg>`,
  );
  const clean = rawPath.replace('.png', '-clean.png');
  await sharp(rawPath)
    .composite([{ input: overlay, top: 0, left: 0 }])
    .png()
    .toFile(clean);
  const fixed = spread(markers);
  await sharp(clean)
    .composite(
      fixed.map((m) => ({
        input: badgeSvg(m.n),
        left: Math.max(0, Math.round(m.x - R)),
        top: Math.max(0, Math.round(m.y - R)),
      })),
    )
    .png()
    .toFile(path.join(OUT, outName));
  console.log(
    'wrote',
    outName,
    fixed.map((m) => `${m.n}@${Math.round(m.x)},${Math.round(m.y)}`).join(' '),
  );
}

async function enableSemantics(page) {
  await page.evaluate(() =>
    document.querySelector('[aria-label="Enable accessibility"]')?.click(),
  );
  await page.waitForTimeout(350);
}

async function nodes(page) {
  return page.evaluate(() => {
    return [...document.querySelectorAll('flt-semantics')].map((n) => {
      const r = n.getBoundingClientRect();
      const t = (n.innerText || n.getAttribute('aria-label') || '')
        .replace(/\s+/g, ' ')
        .trim();
      const role = n.getAttribute('role') || '';
      return {
        t,
        role,
        x: r.x + r.width / 2,
        y: r.y + r.height / 2,
        left: r.x,
        top: r.y,
        w: r.width,
        h: r.height,
      };
    }).filter((b) => b.w > 0 && b.h > 0 && b.t);
  });
}

function pick(list, pred, nth = 0) {
  return list.filter(pred)[nth];
}

function mark(n, el, opt = {}) {
  if (!el) return null;
  return {
    n,
    x: opt.x ?? Math.max(R + 4, el.left + (opt.dx ?? 16)),
    y: opt.y ?? el.y + (opt.dy ?? 0),
  };
}

async function clickBtn(page, pred) {
  const list = await nodes(page);
  const hit = pick(list, (b) => b.role === 'button' && pred(b.t));
  if (!hit) throw new Error(`button miss: ${pred}`);
  await page.mouse.click(hit.x, hit.y);
  await page.waitForTimeout(1000);
}

async function ensureLoggedIn(page) {
  await enableSemantics(page);
  let list = await nodes(page);
  if (pick(list, (b) => b.t.includes('로그아웃'))) return;
  // login form
  const inputs = await page.evaluate(() =>
    [...document.querySelectorAll('input, textarea')]
      .map((el) => {
        const r = el.getBoundingClientRect();
        return { type: el.type, x: r.x + r.width / 2, y: r.y + r.height / 2, w: r.width, h: r.height };
      })
      .filter((e) => e.w > 40)
      .sort((a, b) => a.y - b.y),
  );
  if (inputs.length >= 2) {
    await page.mouse.click(inputs[0].x, inputs[0].y, { clickCount: 3 });
    await page.keyboard.type('geosoft', { delay: 25 });
    await page.mouse.click(inputs[1].x, inputs[1].y, { clickCount: 3 });
    await page.keyboard.type('1234', { delay: 25 });
  }
  try {
    await clickBtn(page, (t) => t.includes('로그인'));
  } catch {
    await page.keyboard.press('Enter');
  }
  await page.waitForTimeout(2500);
  await enableSemantics(page);
}

const browser = await chromium.connectOverCDP(CDP);
const context = browser.contexts()[0];
const page =
  context.pages().find((p) => p.url().includes('localhost')) ||
  context.pages()[0];
await page.setViewportSize(VIEW);
await page.goto(APP, { waitUntil: 'networkidle', timeout: 60000 });
await page.waitForTimeout(2000);
await ensureLoggedIn(page);

// ——— §2 수집 모니터링 ———
await page.goto(`${APP}/#/collection`, { waitUntil: 'networkidle', timeout: 30000 });
await page.waitForTimeout(2500);
await enableSemantics(page);
{
  try {
    await clickBtn(page, (t) => t.includes('수집 모니터링'));
  } catch (_) {}
  await page.waitForTimeout(1500);
  await enableSemantics(page);
  const list = await nodes(page);
  const nav = pick(list, (b) => b.role === 'button' && /^수집 모니터링/.test(b.t) && b.x < 260)
    || pick(list, (b) => b.t === '수집 모니터링' && b.x < 280);
  const date = pick(list, (b) => b.t === '일자' || b.t.startsWith('일자'));
  const query = pick(list, (b) => b.role === 'button' && (b.t === '조회' || b.t.startsWith('조회')));
  const tab = pick(list, (b) => b.t.includes('일자별 수집 타임라인'));
  const res = pick(list, (b) => b.role === 'button' && b.t === '리소스')
    || pick(list, (b) => b.t === '리소스');
  const roadmap = pick(list, (b) => b.role === 'button' && b.t.includes('로드맵'));
  const markers = [
    mark(1, nav, { x: nav ? Math.min(nav.x, 40) : 28, y: nav?.y ?? 100 }),
    mark(2, date, { dx: 20 }),
    mark(3, query),
    mark(4, tab, { dx: 40 }),
    { n: 5, x: 700, y: 560 },
    mark(6, res || roadmap, { dx: 20 }),
  ].filter(Boolean);
  const raw = path.join(OUT, '_raw-collection-monitoring-live.png');
  await page.screenshot({ path: raw, fullPage: false });
  await coverDebugAndAnnotate(raw, markers, '00-collection-monitoring-n.png');
}

// ——— §3 작업 관리 + §5 목록 버튼 ———
await page.goto(`${APP}/#/history`, { waitUntil: 'networkidle', timeout: 30000 });
await page.waitForTimeout(2500);
await enableSemantics(page);
{
  try {
    await clickBtn(page, (t) => t.includes('작업 관리'));
  } catch (_) {}
  await page.waitForTimeout(1200);
  await enableSemantics(page);
  // 조회 눌러 목록 확보
  try {
    await clickBtn(page, (t) => t === '조회' || t.startsWith('조회'));
    await page.waitForTimeout(2000);
    await enableSemantics(page);
  } catch (_) {}
  const list = await nodes(page);
  const nav = pick(list, (b) => b.role === 'button' && b.t.includes('작업 관리') && b.x < 280);
  const query = pick(list, (b) => b.role === 'button' && (b.t === '조회' || b.t.startsWith('조회')));
  const neu = pick(list, (b) => b.role === 'button' && b.t.includes('새 작업'));
  const detail = pick(list, (b) => b.role === 'button' && (b.t === '상세' || b.t.startsWith('상세')));
  const profile = pick(list, (b) => b.role === 'button' && (b.t === '프로파일' || b.t.startsWith('프로파일')));
  const quality = pick(list, (b) => b.role === 'button' && (b.t === '품질' || b.t.startsWith('품질')));
  const raw = path.join(OUT, '_raw-history.png');
  await page.screenshot({ path: raw, fullPage: false });
  await coverDebugAndAnnotate(
    raw,
    [
      mark(1, nav, { x: nav ? Math.min(nav.x, 40) : 28 }),
      mark(2, query),
      mark(3, neu),
      mark(4, detail),
      mark(5, profile),
      mark(6, quality),
    ].filter(Boolean),
    '01-work-history-n.png',
  );
  await coverDebugAndAnnotate(
    raw,
    [mark(1, detail), mark(2, profile), mark(3, quality)].filter(Boolean),
    '06-list-actions-n.png',
  );
}

// ——— §4 새 작업 ———
{
  await clickBtn(page, (t) => t.includes('새 작업'));
  await page.waitForTimeout(1200);
  await enableSemantics(page);
  const list = await nodes(page);
  const gongsa = pick(list, (l) => l.t === '공사' || l.t.startsWith('공사'));
  const hogi = pick(list, (l) => l.t.includes('호기'));
  const ium = pick(list, (l) => l.t === '이음부' || l.t.startsWith('이음부'));
  const worker = pick(list, (l) => l.t === '작업자' || l.t.startsWith('작업자'));
  const start = pick(list, (l) => l.t.startsWith('시작') && !l.t.includes('일'));
  const pass = pick(list, (l) => l.t === '패스' || (l.t.startsWith('패스') && !l.t.includes('추가')));
  const make = pick(list, (b) => b.role === 'button' && b.t.includes('만들기'));
  const raw = path.join(OUT, '_raw-newjob.png');
  await page.screenshot({ path: raw, fullPage: false });
  await coverDebugAndAnnotate(
    raw,
    [
      mark(1, gongsa, { dx: 24 }),
      mark(2, hogi, { dx: 24 }),
      mark(3, ium, { dx: 24 }),
      mark(4, worker, { dx: 24 }),
      mark(5, start, { dx: 24 }),
      mark(6, pass, { dx: 24 }),
      mark(7, make),
    ].filter(Boolean),
    '02-new-job-dialog-n.png',
  );
  try {
    await clickBtn(page, (t) => t.includes('취소'));
  } catch {
    await page.keyboard.press('Escape');
  }
  await page.waitForTimeout(800);
}

// ——— 작업 상세 ———
await page.waitForTimeout(500);
await enableSemantics(page);
await clickBtn(page, (t) => t === '상세' || t.startsWith('상세'));
await page.waitForTimeout(2500);
await enableSemantics(page);

// §6 기본 정보
{
  const list = await nodes(page);
  const summary =
    pick(list, (l) => /공통키|#\d+|EX00/.test(l.t) && l.y < 280) ||
    pick(list, (l) => l.t.includes('공통키'));
  const tab = pick(list, (l) => l.t.includes('기본 정보') || l.t.includes('기본정보'));
  const save = pick(list, (b) => b.role === 'button' && b.t.includes('저장'));
  const erase = pick(list, (b) => b.role === 'button' && b.t.includes('작업 지우기'));
  const form =
    pick(list, (l) => l.t.includes('공사') && l.y > 300) ||
    pick(list, (l) => l.t.includes('품목') && l.y > 300);
  const profile = pick(list, (b) => b.role === 'button' && b.t.includes('프로파일'));
  const quality = pick(list, (b) => b.role === 'button' && b.t.includes('품질'));
  const raw = path.join(OUT, '_raw-info.png');
  await page.screenshot({ path: raw, fullPage: false });
  const m6 = profile || quality;
  await coverDebugAndAnnotate(
    raw,
    [
      mark(1, summary, { dx: 28, dy: -8 }),
      mark(2, tab),
      mark(3, save),
      mark(4, erase),
      mark(5, form, { dx: 24 }),
      mark(6, m6),
    ].filter(Boolean),
    '04-job-detail-info-n.png',
  );
}

// §7 패스
{
  const list0 = await nodes(page);
  const passTab = pick(list0, (b) => b.role === 'button' && /^패스/.test(b.t));
  if (passTab) {
    await page.mouse.click(passTab.x, passTab.y);
    await page.waitForTimeout(1200);
    await enableSemantics(page);
  }
  const list = await nodes(page);
  const add = pick(list, (b) => b.role === 'button' && b.t.includes('패스 추가'));
  const row = pick(list, (l) => /패스|초층|채움|캡/.test(l.t) && l.y > 320 && l.w > 80);
  const note = pick(list, (l) => l.t.includes('작업 구간') || l.t.includes('겹칠'));
  const edit = pick(list, (b) => b.role === 'button' && (b.t.includes('수정') || b.t.includes('편집') || b.t.includes('지우기')) && b.y > 320);
  const raw = path.join(OUT, '_raw-pass.png');
  await page.screenshot({ path: raw, fullPage: false });
  await coverDebugAndAnnotate(
    raw,
    [
      mark(1, add),
      mark(2, row, { dx: 40 }),
      mark(3, edit || (row ? { ...row, left: 1320, x: 1320 } : null)),
      mark(4, note, { dx: 30 }),
    ].filter(Boolean),
    '05-job-detail-pass-n.png',
  );
}

// §8 패스 추가
{
  try {
    await clickBtn(page, (t) => t.includes('패스 추가'));
    await page.waitForTimeout(1000);
    await enableSemantics(page);
    const list = await nodes(page);
    const no = pick(list, (l) => l.t.includes('패스 번호'));
    const kind = pick(list, (l) => l.t === '종류' || l.t.startsWith('종류'));
    const start = pick(list, (l) => l.t.startsWith('시작'));
    const end = pick(list, (l) => l.t.startsWith('종료'));
    const note = pick(list, (l) => l.t.includes('작업 구간') || l.t.includes('비워'));
    const add = pick(list, (b) => b.role === 'button' && (b.t === '추가' || b.t.startsWith('추가')));
    const raw = path.join(OUT, '_raw-pass-add.png');
    await page.screenshot({ path: raw, fullPage: false });
    await coverDebugAndAnnotate(
      raw,
      [
        mark(1, no, { dx: 24 }),
        mark(2, kind, { dx: 24 }),
        mark(3, start, { dx: 24 }),
        mark(4, end, { dx: 24 }),
        mark(5, note, { dx: 24 }),
        mark(6, add),
      ].filter(Boolean),
      '08-pass-add-n.png',
    );
    try {
      await clickBtn(page, (t) => t.includes('취소'));
    } catch {
      await page.keyboard.press('Escape');
    }
    await page.waitForTimeout(600);
  } catch (e) {
    console.warn('pass-add skip', e.message);
  }
}

// §9 첨부
{
  const list0 = await nodes(page);
  const attTab = pick(list0, (b) => b.role === 'button' && /^첨부/.test(b.t));
  if (attTab) {
    await page.mouse.click(attTab.x, attTab.y);
    await page.waitForTimeout(1500);
    await enableSemantics(page);
  }
  const list = await nodes(page);
  console.log(
    'attach buttons',
    list.filter((b) => b.role === 'button').map((b) => b.t).slice(0, 40),
  );
  const upload = pick(list, (b) => b.role === 'button' && b.t.includes('에셋 올리기'));
  const attach = pick(
    list,
    (b) => b.role === 'button' && (b.t.includes('에셋 붙이기') || b.t.includes('붙이기')),
  );
  const passCombo = pick(
    list,
    (b) =>
      (b.role === 'button' || b.t.includes('패스')) &&
      /\d+\s*패스|패스/.test(b.t) &&
      b.y > 380,
  );
  const detach = pick(list, (b) => b.role === 'button' && (b.t.includes('떼기') || b.t.includes('끊')));
  const raw = path.join(OUT, '_raw-attach.png');
  await page.screenshot({ path: raw, fullPage: false });
  await coverDebugAndAnnotate(
    raw,
    [
      mark(1, upload),
      mark(2, attach),
      mark(3, passCombo, { dx: 20 }),
      mark(4, detach || (passCombo ? { left: passCombo.left + 150, x: passCombo.x + 150, y: passCombo.y } : { left: 1360, x: 1360, y: 470 })),
    ].filter(Boolean),
    '06-job-detail-attach-n.png',
  );
}

await browser.close();
fs.writeFileSync(
  path.join(OUT, '_fix-badges-meta.json'),
  JSON.stringify({ cdp: CDP, app: APP, at: new Date().toISOString() }, null, 2),
);
console.log('fix-manual-badges-live done');
