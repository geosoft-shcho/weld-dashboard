/**
 * 실행 중 flutter run -d chrome (CDP)에서 로그인·수집 모니터링 실화면 캡처 + 번호 배지.
 * Chrome remote-debugging-port 와 APP_URL 을 환경변수로 넘길 수 있다.
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

function spreadMarkers(markers) {
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

async function enableSemantics(page) {
  await page.evaluate(() => {
    // Flutter web: a11y 버튼이 있으면 켠다
    const btn = document.querySelector('[aria-label="Enable accessibility"]');
    if (btn) btn.click();
  });
  await page.waitForTimeout(400);
}

async function findButtons(page) {
  return page.evaluate(() => {
    return [...document.querySelectorAll('flt-semantics[role="button"]')]
      .map((n) => {
        const r = n.getBoundingClientRect();
        const t = (n.innerText || n.getAttribute('aria-label') || '')
          .replace(/\s+/g, ' ')
          .trim();
        return {
          t,
          x: r.x + r.width / 2,
          y: r.y + r.height / 2,
          left: r.x,
          top: r.y,
          w: r.width,
          h: r.height,
        };
      })
      .filter((b) => b.w > 0 && b.h > 0);
  });
}

async function findLabels(page) {
  return page.evaluate(() => {
    return [...document.querySelectorAll('flt-semantics')]
      .map((n) => {
        const r = n.getBoundingClientRect();
        const t = (n.innerText || n.getAttribute('aria-label') || '')
          .replace(/\s+/g, ' ')
          .trim();
        return {
          t,
          x: r.x + r.width / 2,
          y: r.y + r.height / 2,
          left: r.x,
          top: r.y,
          w: r.width,
          h: r.height,
        };
      })
      .filter((b) => b.w > 0 && b.h > 0 && b.t);
  });
}

async function clickFirst(page, pred) {
  const hits = (await findButtons(page)).filter((b) => pred(b.t));
  if (!hits.length) throw new Error(`click miss: ${pred}`);
  await page.mouse.click(hits[0].x, hits[0].y);
  await page.waitForTimeout(900);
}

async function fillFieldNearLabel(page, labelPred, value) {
  const labels = await findLabels(page);
  const label = labels.find((l) => labelPred(l.t));
  if (!label) throw new Error('label miss');
  // 라벨 아래 입력 영역 클릭 후 타이핑
  await page.mouse.click(label.x, label.y + 28);
  await page.waitForTimeout(200);
  await page.keyboard.press('Meta+A');
  await page.keyboard.type(value, { delay: 20 });
  await page.waitForTimeout(200);
}

function columnMarkers(items, leftX, y0, step = 48) {
  return items.map((n, i) => ({ n, x: leftX, y: y0 + i * step }));
}

const browser = await chromium.connectOverCDP(CDP);
const context = browser.contexts()[0] || (await browser.newContext());
let page = context.pages().find((p) => p.url().includes('localhost')) || context.pages()[0];
if (!page) {
  page = await context.newPage();
}
await page.setViewportSize(VIEW);
await page.goto(APP, { waitUntil: 'networkidle', timeout: 60000 });
await page.waitForTimeout(2500);
await enableSemantics(page);

// 이미 로그인돼 있으면 로그아웃
{
  const btns = await findButtons(page);
  const logout = btns.find((b) => b.t.includes('로그아웃'));
  if (logout) {
    await page.mouse.click(logout.x, logout.y);
    await page.waitForTimeout(1500);
    await enableSemantics(page);
  }
}

// ——— 로그인 화면 ———
await page.waitForTimeout(800);
let raw = path.join(OUT, '_raw-login-live.png');
await page.screenshot({ path: raw, fullPage: false });

// 배지: 시맨틱으로 잡히면 좌표 사용, 아니면 카드 왼쪽 열
let markers = [];
{
  const labs = await findLabels(page);
  const btns = await findButtons(page);
  console.log(
    'login labels',
    labs.map((l) => l.t).slice(0, 20),
  );
  console.log(
    'login buttons',
    btns.map((b) => b.t).slice(0, 20),
  );
  const title =
    labs.find((l) => /용접|tks\.|대시보드|faivv/i.test(l.t)) ||
    labs.find((l) => l.y < 320 && l.w > 80);
  const idLab = labs.find((l) => /^ID$/i.test(l.t) || l.t === 'ID');
  const pwLab = labs.find((l) => /Password|비밀번호/i.test(l.t));
  const loginBtn = btns.find((b) => b.t.includes('로그인'));
  if (title && idLab && pwLab && loginBtn) {
    markers = [
      { n: 1, x: Math.max(R + 4, title.left + 16), y: title.y },
      { n: 2, x: Math.max(R + 4, idLab.left + 16), y: idLab.y + 20 },
      { n: 3, x: Math.max(R + 4, pwLab.left + 16), y: pwLab.y + 20 },
      { n: 4, x: Math.max(R + 4, loginBtn.left + 16), y: loginBtn.y },
    ];
  } else {
    // 화면 중앙 카드 기준 고정 열 (실화면 레이아웃 가정)
    markers = columnMarkers([1, 2, 3, 4], VIEW.width / 2 - 170, 300, 52);
  }
}
await annotate(raw, markers, '00-login-n.png');

// 게스트 계정으로 로그인 후 모니터링 (조회 일부 불가여도 모니터링은 보임)
try {
  await fillFieldNearLabel(page, (t) => /^ID$/i.test(t) || t === 'ID', 'user');
} catch (e) {
  console.warn('id fill', e.message);
  // 기본값이 있으면 클릭만
  await page.mouse.click(VIEW.width / 2, 360);
  await page.keyboard.press('Meta+A');
  await page.keyboard.type('user', { delay: 20 });
}
try {
  await fillFieldNearLabel(
    page,
    (t) => /Password|비밀번호/i.test(t),
    '1234',
  );
} catch (e) {
  console.warn('pw fill', e.message);
  await page.mouse.click(VIEW.width / 2, 430);
  await page.keyboard.press('Meta+A');
  await page.keyboard.type('1234', { delay: 20 });
}
try {
  await clickFirst(page, (t) => t.includes('로그인'));
} catch (e) {
  console.warn('login click', e.message);
  await page.keyboard.press('Enter');
}
await page.waitForTimeout(2800);
await enableSemantics(page);

// 수집 모니터링으로 이동
try {
  await page.goto(`${APP}/#/collection`, { waitUntil: 'networkidle', timeout: 30000 });
} catch (_) {}
await page.waitForTimeout(2000);
await enableSemantics(page);
{
  const btns = await findButtons(page);
  const mon = btns.find((b) => b.t.includes('수집 모니터링'));
  if (mon) {
    await page.mouse.click(mon.x, mon.y);
    await page.waitForTimeout(2000);
  }
}

raw = path.join(OUT, '_raw-collection-monitoring-live.png');
await page.screenshot({ path: raw, fullPage: false });
{
  const labs = await findLabels(page);
  const btns = await findButtons(page);
  console.log(
    'mon labels sample',
    labs
      .filter((l) =>
        /수집|조회|초기화|새로고침|타임라인|리소스|로드맵|일자|장비|작업/.test(
          l.t,
        ),
      )
      .map((l) => l.t)
      .slice(0, 40),
  );
  console.log(
    'mon buttons sample',
    btns
      .filter((b) =>
        /수집|조회|초기화|새로고침|타임라인|리소스|로드맵/.test(b.t),
      )
      .map((b) => b.t)
      .slice(0, 40),
  );

  const nav = btns.find((b) => b.t.includes('수집 모니터링')) ||
    labs.find((l) => l.t.includes('수집 모니터링') && l.x < 280);
  const query = btns.find((b) => b.t === '조회' || b.t.startsWith('조회'));
  const reset = btns.find((b) => b.t.includes('초기화'));
  const reload = btns.find((b) => b.t.includes('새로고침'));
  const dateLab =
    labs.find((l) => l.t === '일자' || l.t.startsWith('일자')) ||
    labs.find((l) => /시작|종료|보기/.test(l.t) && l.y < 200);
  const tab =
    labs.find((l) => l.t.includes('일자별 수집 타임라인')) ||
    btns.find((b) => b.t.includes('일자별 수집 타임라인'));
  const viewRes =
    btns.find((b) => b.t.includes('리소스')) ||
    labs.find((l) => l.t === '리소스');
  const dayView =
    btns.find((b) => b.t.includes('하루 타임라인')) ||
    labs.find((l) => l.t.includes('하루 타임라인'));

  const m = [];
  if (nav) m.push({ n: 1, x: nav.x < 40 ? 40 : nav.x, y: nav.y });
  else m.push({ n: 1, x: 100, y: 120 });
  if (dateLab) m.push({ n: 2, x: dateLab.left + 20, y: dateLab.y });
  else m.push({ n: 2, x: 320, y: 100 });
  if (query) {
    m.push({
      n: 3,
      x: query.x,
      y: query.y,
    });
  } else if (reset || reload) {
    const a = reset || reload;
    m.push({ n: 3, x: a.x, y: a.y });
  } else {
    m.push({ n: 3, x: 1280, y: 100 });
  }
  if (tab) m.push({ n: 4, x: tab.left + 40, y: tab.y });
  else m.push({ n: 4, x: 280, y: 260 });
  // 타임라인 본문 중앙
  m.push({ n: 5, x: 720, y: 520 });
  if (viewRes) m.push({ n: 6, x: viewRes.x, y: viewRes.y });
  else if (dayView) m.push({ n: 6, x: dayView.x, y: dayView.y });
  else m.push({ n: 6, x: 360, y: 300 });
  await annotate(raw, m, '00-collection-monitoring-n.png');
}

// CDP 연결만 끊고 앱 Chrome은 유지
await browser.close();
console.log('capture-login-monitor-live done');
fs.writeFileSync(
  path.join(OUT, '_live-capture-meta.json'),
  JSON.stringify({ cdp: CDP, app: APP, at: new Date().toISOString() }, null, 2),
);
