import { chromium } from 'playwright';
import { createRequire } from 'module';
import path from 'path';
import { fileURLToPath } from 'url';

const require = createRequire(import.meta.url);
const sharp = require('sharp');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const BASE = 'http://localhost:55730';
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
  console.log('wrote', outName, markers.map((m) => `${m.n}@${Math.round(m.x)},${Math.round(m.y)}`).join(' '));
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
        const t = (n.innerText || '').replace(/\s+/g, ' ').trim();
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
  if (!hits.length) throw new Error('click miss');
  await page.mouse.click(hits[0].x, hits[0].y);
  await page.waitForTimeout(1200);
}

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: VIEW });

// 1) 작업 관리
await page.goto(`${BASE}/#/history`, { waitUntil: 'networkidle', timeout: 60000 });
await page.waitForTimeout(2500);
let raw = path.join(OUT, '_raw-history.png');
await page.screenshot({ path: raw, fullPage: false });
let btns = await findButtons(page);
const pick = (pred, nth = 0) => btns.filter(pred)[nth];

const mHistory = [];
const nav = pick((b) => b.t.includes('작업 관리'));
const search = pick((b) => b.t.includes('조회'));
const neu = pick((b) => b.t.includes('새 작업'));
const detail = pick((b) => b.t === '상세' || b.t.startsWith('상세'));
const profile = pick((b) => b.t === '프로파일' || b.t.startsWith('프로파일'));
const quality = pick((b) => b.t === '품질' || b.t.startsWith('품질'));
if (nav) mHistory.push({ n: 1, x: nav.x, y: nav.y });
if (search) mHistory.push({ n: 2, x: search.x, y: search.y });
if (neu) mHistory.push({ n: 3, x: neu.x, y: neu.y });
if (detail) mHistory.push({ n: 4, x: detail.x, y: detail.y });
if (profile) mHistory.push({ n: 5, x: profile.x, y: profile.y });
if (quality) mHistory.push({ n: 6, x: quality.x, y: quality.y });
await annotate(raw, mHistory, '01-work-history-n.png');

const mActions = [];
if (detail) mActions.push({ n: 1, x: detail.x, y: detail.y });
if (profile) mActions.push({ n: 2, x: profile.x, y: profile.y });
if (quality) mActions.push({ n: 3, x: quality.x, y: quality.y });
await annotate(raw, mActions, '06-list-actions-n.png');

// 2) 새 작업
await clickFirst(page, (t) => t.includes('새 작업'));
await page.waitForTimeout(1000);
raw = path.join(OUT, '_raw-newjob.png');
await page.screenshot({ path: raw, fullPage: false });
const labels = await findLabels(page);
const findL = (pred) => labels.find(pred);
const mNew = [];
const gongsa = findL((l) => l.t.startsWith('공사') || l.t === '공사');
const hogi = findL((l) => l.t.includes('호기'));
const ium = findL((l) => l.t.startsWith('이음부') || l.t === '이음부');
const worker = findL((l) => l.t.startsWith('작업자') || l.t === '작업자');
const start = findL((l) => l.t.startsWith('시작') && !l.t.includes('일'));
const pass = findL((l) => l.t === '패스' || (l.t.startsWith('패스') && !l.t.includes('추가')));
const make = (await findButtons(page)).find((b) => b.t.includes('만들기'));
if (gongsa) mNew.push({ n: 1, x: gongsa.left + 24, y: gongsa.y });
if (hogi) mNew.push({ n: 2, x: hogi.left + 24, y: hogi.y });
if (ium) mNew.push({ n: 3, x: ium.left + 24, y: ium.y });
if (worker) mNew.push({ n: 4, x: worker.left + 24, y: worker.y });
if (start) mNew.push({ n: 5, x: start.left + 24, y: start.y });
if (pass) mNew.push({ n: 6, x: pass.left + 24, y: pass.y });
if (make) mNew.push({ n: 7, x: make.x, y: make.y });
console.log(
  'newjob labels',
  labels
    .filter((l) => /공사|호기|이음|작업자|시작|패스|만들기/.test(l.t))
    .map((l) => l.t)
    .slice(0, 30),
);
await annotate(raw, mNew, '02-new-job-dialog-n.png');

try {
  await clickFirst(page, (t) => t.includes('취소'));
} catch {
  await page.keyboard.press('Escape');
}
await page.waitForTimeout(800);

// 3) 작업 상세
await clickFirst(page, (t) => t === '상세' || t.startsWith('상세'));
await page.waitForTimeout(2200);
raw = path.join(OUT, '_raw-info.png');
await page.screenshot({ path: raw, fullPage: false });
btns = await findButtons(page);
let labs = await findLabels(page);
const mInfo = [];
const ctx = labs.find((l) => l.t.includes('공통키'));
const tabInfo = labs.find((l) => l.t.includes('기본 정보') || l.t.includes('기본정보'));
const save = btns.find((b) => b.t.includes('저장'));
const erase = btns.find((b) => b.t.includes('작업 지우기'));
const formGongsa = labs.find((l) => l.t.includes('공사') && l.y > 280);
const topProfile = btns.find((b) => b.t.includes('프로파일'));
if (ctx) mInfo.push({ n: 1, x: ctx.left + 28, y: ctx.top + 12 });
if (tabInfo) mInfo.push({ n: 2, x: tabInfo.x, y: tabInfo.y });
if (save) mInfo.push({ n: 3, x: save.x, y: save.y });
if (erase) mInfo.push({ n: 4, x: erase.x, y: erase.y });
if (formGongsa) mInfo.push({ n: 5, x: formGongsa.left + 24, y: formGongsa.y });
if (topProfile) mInfo.push({ n: 6, x: topProfile.x, y: topProfile.y });
await annotate(raw, mInfo, '04-job-detail-info-n.png');

// pass
{
  const passTab = btns.find((b) => /^패스\s*\d+/.test(b.t));
  if (passTab) {
    await page.mouse.click(passTab.x, passTab.y);
    await page.waitForTimeout(1000);
  }
}
raw = path.join(OUT, '_raw-pass.png');
await page.screenshot({ path: raw, fullPage: false });
btns = await findButtons(page);
labs = await findLabels(page);
const mPass = [];
const addPass = btns.find((b) => b.t.includes('패스 추가'));
const passRow = labs.find((l) => /1패스|초층/.test(l.t));
const note = labs.find((l) => l.t.includes('작업 구간') || l.t.includes('겹칠'));
if (addPass) mPass.push({ n: 1, x: addPass.x, y: addPass.y });
if (passRow) mPass.push({ n: 2, x: passRow.left + 50, y: passRow.y });
if (passRow) mPass.push({ n: 3, x: 1320, y: passRow.y });
if (note) mPass.push({ n: 4, x: note.left + 40, y: note.y });
await annotate(raw, mPass, '05-job-detail-pass-n.png');

// attach
{
  const att = btns.find((b) => /^첨부\s*\d+/.test(b.t));
  if (att) {
    await page.mouse.click(att.x, att.y);
    await page.waitForTimeout(1000);
  }
}
raw = path.join(OUT, '_raw-attach.png');
await page.screenshot({ path: raw, fullPage: false });
btns = await findButtons(page);
labs = await findLabels(page);
const mAtt = [];
const upload = btns.find((b) => b.t.includes('올리기'));
const attach = btns.find((b) => b.t.includes('붙이기'));
const passCombo = btns.find((b) => /\d+패스/.test(b.t) && b.y > 400);
if (upload) mAtt.push({ n: 1, x: upload.x, y: upload.y });
if (attach) mAtt.push({ n: 2, x: attach.x, y: attach.y });
if (passCombo) mAtt.push({ n: 3, x: passCombo.x, y: passCombo.y });
else mAtt.push({ n: 3, x: 1180, y: 470 });
mAtt.push({ n: 4, x: 1360, y: 470 });
await annotate(raw, mAtt, '06-job-detail-attach-n.png');

// profile
await page.goto(`${BASE}/#/history`, { waitUntil: 'networkidle' });
await page.waitForTimeout(2000);
await clickFirst(page, (t) => t.includes('프로파일'));
await page.waitForTimeout(2800);
raw = path.join(OUT, '_raw-profile.png');
await page.screenshot({ path: raw, fullPage: false });
labs = await findLabels(page);
const mProf = [];
const p1 = labs.find((l) => l.t === 'P1' || /^P1\b/.test(l.t));
const current = labs.find((l) => l.t.includes('전류'));
const ctx2 = labs.find((l) => l.t.includes('공통키'));
if (ctx2) mProf.push({ n: 1, x: ctx2.left + 28, y: ctx2.top + 12 });
if (p1) mProf.push({ n: 2, x: p1.x, y: p1.y });
if (current) mProf.push({ n: 3, x: current.left + 50, y: current.y + 50 });
await annotate(raw, mProf, '08-pass-profile-n.png');

// quality
await page.goto(`${BASE}/#/history`, { waitUntil: 'networkidle' });
await page.waitForTimeout(2000);
await clickFirst(page, (t) => t === '품질' || t.startsWith('품질'));
await page.waitForTimeout(2800);
raw = path.join(OUT, '_raw-quality.png');
await page.screenshot({ path: raw, fullPage: false });
labs = await findLabels(page);
const mQ = [];
const qp1 = labs.find((l) => l.t === 'P1');
const pdf = labs.find((l) => /\.pdf/i.test(l.t) || l.t.includes('pdf'));
const wave = labs.find((l) => l.t.includes('전류'));
if (qp1) mQ.push({ n: 1, x: qp1.x, y: qp1.y });
if (pdf) mQ.push({ n: 2, x: Math.min(pdf.x, 500), y: Math.max(pdf.y, 380) });
else mQ.push({ n: 2, x: 420, y: 520 });
if (wave) mQ.push({ n: 3, x: wave.left + 40, y: wave.y + 40 });
await annotate(raw, mQ, '09-quality-issue-n.png');

await browser.close();
console.log('annotate done');
