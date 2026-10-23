const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 5, title: '새 작업 만들기' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('2. 새 작업 만들기', {
    x: 0.35,
    y: 0.12,
    w: 6,
    h: 0.28,
    fontSize: 20,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  slide.addText('[새 작업]을 누르면 창이 열립니다. 번호를 따라 채운 뒤 [만들기]를 누릅니다.', {
    x: 0.35,
    y: 0.4,
    w: 9.2,
    h: 0.24,
    fontSize: 12,
    fontFace: 'Arial',
    color: theme.secondary,
    margin: 0,
  });
  slide.addImage({
    path: img('02-new-job-dialog-n.png'),
    x: 0.3,
    y: 0.7,
    w: 6.55,
    h: 4.1,
  });
  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x: 7.05,
    y: 0.7,
    w: 2.6,
    h: 4.1,
    fill: { color: theme.primary },
    rectRadius: 0.08,
  });
  slide.addText('번호 안내', {
    x: 7.2,
    y: 0.9,
    w: 2.3,
    h: 0.28,
    fontSize: 13,
    fontFace: 'Arial',
    color: theme.light,
    bold: true,
    margin: 0,
  });
  addNumberedNotes(
    slide,
    pres,
    theme,
    [
      { n: 1, t: '공사 (필수)' },
      { n: 2, t: '호기 · 품목 (필수)' },
      { n: 3, t: '이음부 (필수)' },
      { n: 4, t: '작업자 (선택)' },
      { n: 5, t: '시작 · 종료 시각' },
      { n: 6, t: '패스 구간 (선택)' },
      { n: 7, t: '[만들기]로 저장' },
    ],
    { x: 7.2, y: 1.3, w: 2.3, gap: 0.45, fontSize: 12, dark: true },
  );
  addBadge(slide, pres, theme, 5);
  return slide;
}

module.exports = { createSlide, slideConfig };
