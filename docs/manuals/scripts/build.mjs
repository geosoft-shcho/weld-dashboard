#!/usr/bin/env node
/**
 * 마크다운 원본 + 톤 프리셋 → md / docx / pptx / pdf
 *
 * 사용:
 *   node scripts/build.mjs --source 작업_등록_매뉴얼 --tone field --format all
 */
import { createRequire } from 'module';
import { spawnSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const require = createRequire(import.meta.url);
const pptxgen = require('pptxgenjs');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const REPO = path.resolve(ROOT, '../..');

function arg(name, fallback = '') {
  const i = process.argv.indexOf(`--${name}`);
  if (i >= 0 && process.argv[i + 1]) return process.argv[i + 1];
  return fallback;
}

const sourceName = arg('source', '작업_등록_매뉴얼');
const toneId = arg('tone', 'field');
const formatArg = arg('format', 'all');
const formats =
  formatArg === 'all'
    ? ['md', 'docx', 'pptx', 'pdf']
    : formatArg.split(',').map((s) => s.trim());

const sourcePath = path.join(ROOT, 'sources', `${sourceName}.md`);
const tonePath = path.join(ROOT, 'tones', `${toneId}.json`);
const outDir = path.join(ROOT, 'output', `${sourceName}__${toneId}`);

if (!fs.existsSync(sourcePath)) {
  console.error('원본 없음:', sourcePath);
  process.exit(1);
}
if (!fs.existsSync(tonePath)) {
  console.error('톤 없음:', tonePath);
  process.exit(1);
}

fs.mkdirSync(outDir, { recursive: true });

const tone = JSON.parse(fs.readFileSync(tonePath, 'utf8'));
let md = fs.readFileSync(sourcePath, 'utf8');

// 톤 플레이스홀더
const slots = {
  cover_kicker: tone.cover_kicker || '',
  cover_lead: tone.cover_lead || '',
  section_lead: tone.section_lead || '',
  audience: tone.audience || '',
  voice: tone.voice || '',
};
for (const [key, value] of Object.entries(slots)) {
  md = md.split(`{{${key}}}`).join(value);
}

// 문장 치환 (긴 키부터)
const phrases = tone.phrases || {};
for (const key of Object.keys(phrases).sort((a, b) => b.length - a.length)) {
  md = md.split(key).join(phrases[key]);
}

// 빈 section_lead 줄 정리
md = md.replace(/\n\{\{section_lead\}\}\n/g, '\n');
md = md.replace(/\n{3,}/g, '\n\n');

const renderedMd = path.join(outDir, `${sourceName}.md`);
fs.writeFileSync(renderedMd, md, 'utf8');
console.log('md   ', renderedMd);

function resolveImage(relFromSource) {
  // sources/ 기준 상대경로 → 절대경로
  const abs = path.resolve(path.dirname(sourcePath), relFromSource);
  return abs;
}

function parseSections(markdown) {
  // YAML front matter 제거
  let body = markdown;
  if (body.startsWith('---')) {
    const end = body.indexOf('\n---', 3);
    if (end >= 0) body = body.slice(end + 4).trimStart();
  }
  const lines = body.split('\n');
  const sections = [];
  let current = null;
  for (const line of lines) {
    const m = /^(#{1,2})\s+(.+)$/.exec(line);
    if (m && m[1].length <= 2) {
      // # 제목은 표지, ## 는 본문 절
      if (current) sections.push(current);
      current = { level: m[1].length, title: stripMd(m[2]), lines: [] };
    } else if (current) {
      current.lines.push(line);
    }
  }
  if (current) sections.push(current);
  return sections;
}

function extractImages(text) {
  const out = [];
  const re = /!\[([^\]]*)\]\(([^)]+)\)/g;
  let m;
  while ((m = re.exec(text))) {
    out.push({ alt: m[1], src: m[2] });
  }
  return out;
}

/** PPTX용: 마크다운 강조·인라인 기호 제거 (화면에 ** 가 보이지 않게) */
function stripMd(s) {
  return String(s ?? '')
    .replace(/\*\*([^*]+)\*\*/g, '$1')
    .replace(/__([^_]+)__/g, '$1')
    .replace(/\*([^*]+)\*/g, '$1')
    .replace(/_([^_]+)_/g, '$1')
    .replace(/`([^`]+)`/g, '$1')
    .replace(/\*\*/g, '')
    .replace(/__/g, '')
    .trim();
}

function extractNumberTable(text) {
  // | 번호 | ... | 표에서 안내 행만 추출 (①·숫자로 시작하는 행만 — 종류 표 등은 제외)
  const rows = [];
  for (const line of text.split('\n')) {
    if (!line.trim().startsWith('|')) continue;
    if (/^\|\s*:?---/.test(line)) continue;
    const cells = line
      .split('|')
      .map((c) => stripMd(c.trim()))
      .filter(Boolean);
    if (cells.length < 2) continue;
    if (cells[0] === '번호' || cells[0] === '종류' || cells[0] === '항목') continue;
    // 캡처에 찍힌 번호 행만 (①-⑳ 또는 숫자)
    if (!/^[①-⑳0-9]+$/.test(cells[0].replace(/\s/g, ''))) continue;
    rows.push(cells);
  }
  return rows;
}

function plainParagraphs(text) {
  return text
    .replace(/!\[[^\]]*\]\([^)]+\)/g, '')
    .replace(/\|[^\n]+\|/g, '')
    .replace(/^#{1,6}\s+.+$/gm, '')
    .replace(/^\s*\d+\.\s+.+$/gm, '')
    .split(/\n{2,}/)
    .map((p) => stripMd(p.replace(/\n/g, ' ')))
    .filter((p) => p && !p.startsWith('|') && p !== '---');
}

/** `1. 제목 — 설명` 형태 번호 목록 */
function extractNumberedItems(text) {
  const items = [];
  for (const line of text.split('\n')) {
    const m = /^\s*(\d+)\.\s+(.+)$/.exec(line);
    if (!m) continue;
    const raw = stripMd(m[2]);
    const parts = raw.split(/\s+[—–-]\s+/);
    items.push({
      num: m[1],
      title: parts[0].trim(),
      detail: parts.slice(1).join(' — ').trim(),
    });
  }
  return items;
}

function addPageBadge(slide, pres, theme, page) {
  slide.addShape(pres.shapes.OVAL, {
    x: 9.3,
    y: 5.1,
    w: 0.4,
    h: 0.4,
    fill: { color: theme.accent },
  });
  slide.addText(String(page), {
    x: 9.3,
    y: 5.1,
    w: 0.4,
    h: 0.4,
    fontSize: 12,
    fontFace: 'Arial',
    color: 'FFFFFF',
    bold: true,
    align: 'center',
    valign: 'middle',
    margin: 0,
  });
}

/** 텍스트 전용 슬라이드: 목차 · 전체 순서 · 끝으로 */
function renderTextSlide(slide, pres, theme, section, body, paras) {
  const items = extractNumberedItems(body);
  const title = section.title;
  const isToc = title === '목차';
  const isFlow = /전체\s*순서/.test(title);
  const isClose = title === '끝으로';

  // 제목
  slide.addText(title, {
    x: 0.4,
    y: 0.22,
    w: 9,
    h: 0.4,
    fontSize: 22,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  // 액센트 밑줄
  slide.addShape(pres.shapes.RECTANGLE, {
    x: 0.4,
    y: 0.62,
    w: 1.2,
    h: 0.05,
    fill: { color: theme.accent },
  });

  if (isToc && items.length) {
    // 1단 목차 — 제목 + 상세, 글자 축소
    const top = 0.78;
    const bottom = 5.0;
    const rowH = Math.min(0.32, (bottom - top) / items.length);
    items.forEach((it, i) => {
      const y = top + i * rowH;
      const label = it.detail ? `${it.title} — ${it.detail}` : it.title;
      slide.addText(it.num, {
        x: 0.4,
        y,
        w: 0.35,
        h: rowH - 0.02,
        fontSize: 11,
        fontFace: 'Arial',
        color: theme.secondary,
        bold: true,
        valign: 'middle',
        margin: 0,
      });
      slide.addText(label, {
        x: 0.8,
        y,
        w: 8.6,
        h: rowH - 0.02,
        fontSize: 11,
        fontFace: 'Arial',
        color: theme.primary,
        valign: 'middle',
        margin: 0,
      });
    });
    return;
  }

  if (isFlow && items.length) {
    // 안내 문단
    const intro = paras.find((p) => !/한 줄로/.test(p)) || paras[0] || '';
    if (intro) {
      slide.addText(intro, {
        x: 0.4,
        y: 0.8,
        w: 9.2,
        h: 0.35,
        fontSize: 13,
        fontFace: 'Arial',
        color: '4A5560',
        margin: 0,
      });
    }
    // 가로 단계 카드
    const n = items.length;
    const gap = 0.25;
    const totalW = 9.2;
    const cardW = (totalW - gap * (n - 1)) / n;
    items.forEach((it, i) => {
      const x = 0.4 + i * (cardW + gap);
      const y = 1.35;
      slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
        x,
        y,
        w: cardW,
        h: 2.55,
        fill: { color: 'FFFFFF' },
        rectRadius: 0.1,
      });
      slide.addShape(pres.shapes.RECTANGLE, {
        x,
        y,
        w: cardW,
        h: 0.1,
        fill: { color: i === 0 ? theme.accent : theme.secondary },
      });
      slide.addShape(pres.shapes.OVAL, {
        x: x + cardW / 2 - 0.28,
        y: y + 0.35,
        w: 0.56,
        h: 0.56,
        fill: { color: theme.primary },
      });
      slide.addText(it.num, {
        x: x + cardW / 2 - 0.28,
        y: y + 0.35,
        w: 0.56,
        h: 0.56,
        fontSize: 18,
        fontFace: 'Arial',
        color: 'FFFFFF',
        bold: true,
        align: 'center',
        valign: 'middle',
        margin: 0,
      });
      slide.addText(it.title, {
        x: x + 0.15,
        y: y + 1.1,
        w: cardW - 0.3,
        h: 0.4,
        fontSize: 15,
        fontFace: 'Arial',
        color: theme.primary,
        bold: true,
        align: 'center',
        margin: 0,
      });
      if (it.detail) {
        slide.addText(it.detail, {
          x: x + 0.18,
          y: y + 1.55,
          w: cardW - 0.36,
          h: 0.85,
          fontSize: 12,
          fontFace: 'Arial',
          color: '4A5560',
          align: 'center',
          margin: 0,
        });
      }
      // 화살표 (마지막 제외)
      if (i < n - 1) {
        slide.addText('→', {
          x: x + cardW - 0.05,
          y: y + 1.05,
          w: gap + 0.1,
          h: 0.35,
          fontSize: 16,
          fontFace: 'Arial',
          color: theme.accent,
          align: 'center',
          margin: 0,
        });
      }
    });
    // 한 줄 요약 배너
    const summary =
      paras.find((p) => /한 줄로|먼저 잡고|정리한 뒤/.test(p)) || '';
    if (summary) {
      slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
        x: 0.4,
        y: 4.15,
        w: 9.2,
        h: 0.7,
        fill: { color: theme.primary },
        rectRadius: 0.08,
      });
      slide.addText(summary.replace(/^한 줄로 말하면:\s*/, ''), {
        x: 0.55,
        y: 4.25,
        w: 8.9,
        h: 0.5,
        fontSize: 13,
        fontFace: 'Arial',
        color: 'FFFFFF',
        align: 'center',
        valign: 'middle',
        margin: 0,
      });
    }
    return;
  }

  if (isClose && items.length) {
    const lead = paras[0] || '등록이 끝나면 아래만 다시 확인해 주세요.';
    slide.addText(lead, {
      x: 0.4,
      y: 0.8,
      w: 9.2,
      h: 0.35,
      fontSize: 14,
      fontFace: 'Arial',
      color: '4A5560',
      margin: 0,
    });
    const rowH = Math.min(0.52, 3.2 / items.length);
    items.forEach((it, i) => {
      const y = 1.25 + i * rowH;
      slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
        x: 0.4,
        y,
        w: 9.2,
        h: rowH - 0.08,
        fill: { color: i % 2 === 0 ? 'FFFFFF' : 'EEF6F4' },
        rectRadius: 0.06,
      });
      slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
        x: 0.55,
        y: y + (rowH - 0.08) / 2 - 0.14,
        w: 0.28,
        h: 0.28,
        fill: { color: theme.secondary },
        rectRadius: 0.04,
      });
      slide.addText('✓', {
        x: 0.55,
        y: y + (rowH - 0.08) / 2 - 0.14,
        w: 0.28,
        h: 0.28,
        fontSize: 12,
        fontFace: 'Arial',
        color: 'FFFFFF',
        bold: true,
        align: 'center',
        valign: 'middle',
        margin: 0,
      });
      slide.addText(`${it.num}.  ${it.title}${it.detail ? ` — ${it.detail}` : ''}`, {
        x: 1.0,
        y,
        w: 8.4,
        h: rowH - 0.08,
        fontSize: 14,
        fontFace: 'Arial',
        color: theme.primary,
        valign: 'middle',
        margin: 0,
      });
    });
    const footer = paras.find((p) => /문의|담당/.test(p));
    if (footer) {
      slide.addText(footer, {
        x: 0.4,
        y: 4.55,
        w: 8.8,
        h: 0.3,
        fontSize: 12,
        fontFace: 'Arial',
        color: theme.secondary,
        margin: 0,
      });
    }
    return;
  }

  // 기타 텍스트: 번호 목록이면 세로 카드, 아니면 문단
  if (items.length) {
    items.forEach((it, i) => {
      const y = 0.85 + i * 0.7;
      if (y > 4.6) return;
      slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
        x: 0.4,
        y,
        w: 9.2,
        h: 0.6,
        fill: { color: 'FFFFFF' },
        rectRadius: 0.06,
      });
      slide.addShape(pres.shapes.OVAL, {
        x: 0.55,
        y: y + 0.14,
        w: 0.32,
        h: 0.32,
        fill: { color: theme.accent },
      });
      slide.addText(it.num, {
        x: 0.55,
        y: y + 0.14,
        w: 0.32,
        h: 0.32,
        fontSize: 12,
        fontFace: 'Arial',
        color: 'FFFFFF',
        bold: true,
        align: 'center',
        valign: 'middle',
        margin: 0,
      });
      slide.addText(
        it.detail ? `${it.title} — ${it.detail}` : it.title,
        {
          x: 1.05,
          y: y + 0.1,
          w: 8.3,
          h: 0.4,
          fontSize: 14,
          fontFace: 'Arial',
          color: theme.primary,
          valign: 'middle',
          margin: 0,
        },
      );
    });
  } else {
    slide.addText(paras.slice(0, 8).join('\n\n'), {
      x: 0.5,
      y: 0.9,
      w: 9,
      h: 3.8,
      fontSize: 15,
      fontFace: 'Arial',
      color: '4A5560',
      margin: 0,
    });
  }
}

async function buildPptx(markdown) {
  const theme = {
    primary: '264653',
    secondary: '2a9d8f',
    accent: 'e76f51',
    light: 'e9c46a',
    bg: 'f7f5f0',
  };
  const pres = new pptxgen();
  pres.layout = 'LAYOUT_16x9';
  pres.author = 'weld-dashboard';
  pres.title = sourceName;

  const sections = parseSections(markdown);
  let page = 0;

  for (const section of sections) {
    page += 1;
    const slide = pres.addSlide();
    slide.background = { color: theme.bg };
    const body = section.lines.join('\n');
    const images = extractImages(body);
    const table = extractNumberTable(body);
    const paras = plainParagraphs(body);
    const numbered = extractNumberedItems(body);

    if (section.level === 1) {
      // 표지
      slide.background = { color: theme.primary };
      slide.addShape(pres.shapes.RECTANGLE, {
        x: 0,
        y: 0,
        w: 0.18,
        h: 5.625,
        fill: { color: theme.accent },
      });
      slide.addText(tone.cover_kicker || '용접 수집 대시보드', {
        x: 0.7,
        y: 1.4,
        w: 8.5,
        h: 0.35,
        fontSize: 14,
        fontFace: 'Arial',
        color: theme.light,
        margin: 0,
      });
      slide.addText(section.title, {
        x: 0.7,
        y: 1.9,
        w: 8.5,
        h: 0.85,
        fontSize: 36,
        fontFace: 'Arial',
        color: 'FFFFFF',
        bold: true,
        margin: 0,
      });
      slide.addText(tone.cover_lead || '', {
        x: 0.7,
        y: 2.95,
        w: 8.2,
        h: 1.2,
        fontSize: 15,
        fontFace: 'Arial',
        color: 'D9E2E5',
        margin: 0,
      });
      continue;
    }

    const imgPath = images[0] ? resolveImage(images[0].src) : null;
    const hasImg = imgPath && fs.existsSync(imgPath);
    const hasNotes = table.length > 0;
    const textOnly = !hasImg && !hasNotes;

    // 목차 · 전체 순서 · 끝으로 등 텍스트 전용
    if (
      textOnly &&
      (section.title === '목차' ||
        section.title === '끝으로' ||
        /전체\s*순서/.test(section.title) ||
        numbered.length > 0)
    ) {
      renderTextSlide(slide, pres, theme, section, body, paras);
      addPageBadge(slide, pres, theme, page);
      continue;
    }

    slide.addText(section.title, {
      x: 0.35,
      y: 0.15,
      w: 9,
      h: 0.35,
      fontSize: 18,
      fontFace: 'Arial',
      color: theme.primary,
      bold: true,
      margin: 0,
    });

    // 제목 바로 아래 설명(section_lead·첫 문단)은 넣지 않음 — 캡처·번호 안내만
    const contentTop = 0.55;

    if (hasImg && hasNotes) {
      slide.addImage({
        path: imgPath,
        x: 0.3,
        y: contentTop,
        w: 6.4,
        h: 4.4,
      });
      slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
        x: 6.9,
        y: contentTop,
        w: 2.75,
        h: 4.4,
        fill: { color: 'FFFFFF' },
        rectRadius: 0.08,
      });
      slide.addText('번호 안내', {
        x: 7.05,
        y: contentTop + 0.15,
        w: 2.45,
        h: 0.28,
        fontSize: 13,
        fontFace: 'Arial',
        color: theme.accent,
        bold: true,
        margin: 0,
      });
      const gap = Math.min(0.55, 3.8 / Math.max(table.length, 1));
      table.forEach((cells, i) => {
        const y = contentTop + 0.55 + i * gap;
        const num = String(cells[0]).replace(/[①-⑳]/g, (ch) =>
          String(ch.charCodeAt(0) - '①'.charCodeAt(0) + 1),
        );
        slide.addShape(pres.shapes.OVAL, {
          x: 7.05,
          y: y + 0.02,
          w: 0.26,
          h: 0.26,
          fill: { color: theme.accent },
        });
        slide.addText(num.replace(/[^0-9]/g, '') || String(i + 1), {
          x: 7.05,
          y: y + 0.02,
          w: 0.26,
          h: 0.26,
          fontSize: 11,
          fontFace: 'Arial',
          color: 'FFFFFF',
          bold: true,
          align: 'center',
          valign: 'middle',
          margin: 0,
        });
        slide.addText(cells.slice(1).join(' — '), {
          x: 7.4,
          y,
          w: 2.1,
          h: gap - 0.05,
          fontSize: 11,
          fontFace: 'Arial',
          color: '4A5560',
          margin: 0,
        });
      });
    } else if (hasImg) {
      slide.addImage({
        path: imgPath,
        x: 0.6,
        y: contentTop,
        w: 8.8,
        h: 4.3,
      });
    } else if (table.length) {
      const rows = table.map((cells) =>
        cells.map((c) => ({
          text: c,
          options: { fontSize: 12, fontFace: 'Arial', color: '264653' },
        })),
      );
      slide.addTable(rows, {
        x: 0.4,
        y: contentTop,
        w: 9.2,
        colW: rows[0]?.length === 4 ? [1.8, 2.4, 1.8, 3.2] : undefined,
        border: [
          { type: 'solid', pt: 0.5, color: 'D0D5D8' },
          { type: 'solid', pt: 0.5, color: 'D0D5D8' },
          { type: 'solid', pt: 0.5, color: 'D0D5D8' },
          { type: 'solid', pt: 0.5, color: 'D0D5D8' },
        ],
        fontFace: 'Arial',
        color: '4A5560',
        fontSize: 12,
      });
    } else if (paras.length) {
      slide.addText(paras.slice(0, 8).join('\n\n'), {
        x: 0.5,
        y: contentTop,
        w: 9,
        h: 4.0,
        fontSize: 15,
        fontFace: 'Arial',
        color: '4A5560',
        margin: 0,
      });
    }

    addPageBadge(slide, pres, theme, page);
  }

  const out = path.join(outDir, `${sourceName}.pptx`);
  await pres.writeFile({ fileName: out });
  console.log('pptx ', out);

  // 기존 경로에도 복사 (현장용 기본 톤일 때)
  if (toneId === 'field') {
    const legacy = path.join(REPO, 'docs/2026-10-23', `${sourceName}.pptx`);
    fs.copyFileSync(out, legacy);
    console.log('copy ', legacy);
  }
}

function buildDocx(mdFile) {
  const out = path.join(outDir, `${sourceName}.docx`);
  const r = spawnSync(
    'pandoc',
    [mdFile, '-o', out, '--resource-path', path.dirname(sourcePath)],
    { encoding: 'utf8' },
  );
  if (r.status !== 0) {
    console.error(r.stderr || r.stdout);
    throw new Error('pandoc docx 실패');
  }
  console.log('docx ', out);
}

async function buildPdf(mdFile) {
  // HTML 중간본 → Playwright 인쇄
  const htmlOut = path.join(outDir, `${sourceName}.html`);
  const r = spawnSync(
    'pandoc',
    [
      mdFile,
      '-o',
      htmlOut,
      '--standalone',
      '--metadata',
      `title=${sourceName}`,
      '--resource-path',
      path.dirname(sourcePath),
      '-c',
      path.join(ROOT, 'scripts/print.css'),
    ],
    { encoding: 'utf8' },
  );
  if (r.status !== 0) {
    console.warn('html 중간본 실패, PDF 생략:', r.stderr || r.stdout);
    return;
  }

  let playwright;
  try {
    playwright = require('playwright');
  } catch {
    // manuals 폴더에 없으면 상위 /tmp 또는 slides의 것을 시도하지 않고 안내
    console.warn(
      'PDF 생략: playwright 없음. `cd docs/manuals && npm i -D playwright && npx playwright install chromium` 후 다시 실행하세요.',
    );
    return;
  }

  const browser = await playwright.chromium.launch({ headless: true });
  const page = await browser.newPage();
  await page.goto(`file://${htmlOut}`, { waitUntil: 'networkidle' });
  const pdfOut = path.join(outDir, `${sourceName}.pdf`);
  await page.pdf({
    path: pdfOut,
    format: 'A4',
    printBackground: true,
    margin: { top: '18mm', bottom: '18mm', left: '16mm', right: '16mm' },
  });
  await browser.close();
  console.log('pdf  ', pdfOut);
}

const cssPath = path.join(ROOT, 'scripts/print.css');
if (!fs.existsSync(cssPath)) {
  fs.writeFileSync(
    cssPath,
    `body{font-family:-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Noto Sans KR",sans-serif;line-height:1.55;color:#222;max-width:900px;margin:0 auto;padding:24px}
img{max-width:100%;height:auto;border:1px solid #ddd}
table{border-collapse:collapse;width:100%;margin:12px 0;font-size:14px}
th,td{border:1px solid #ccc;padding:6px 8px;text-align:left}
th{background:#f3f3f3}
h1,h2{color:#264653}
h2{page-break-before:always}
h2:first-of-type{page-break-before:avoid}
`,
    'utf8',
  );
}

(async () => {
  if (formats.includes('docx')) buildDocx(renderedMd);
  if (formats.includes('pptx')) await buildPptx(md);
  if (formats.includes('pdf')) await buildPdf(renderedMd);
  console.log('done →', outDir);
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
