const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 9, title: '패스 추가' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };

  slide.addText('5-1. 작업 상세 — 패스 추가 창', {
    x: 0.35,
    y: 0.12,
    w: 8,
    h: 0.28,
    fontSize: 18,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  slide.addText(
    '패스 탭에서 [+ 패스 추가]를 누르면 이 창이 열립니다. 화면의 번호와 오른쪽 설명을 같이 보세요.',
    {
      x: 0.35,
      y: 0.4,
      w: 9.2,
      h: 0.24,
      fontSize: 12,
      fontFace: 'Arial',
      color: theme.secondary,
      margin: 0,
    },
  );

  slide.addImage({
    path: img('08-pass-add-n.png'),
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
    y: 0.88,
    w: 2.3,
    h: 0.26,
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
      { n: 1, t: '패스 번호 *\n중복되면 안 됨' },
      { n: 2, t: '종류\n초층·채움·캡 등' },
      { n: 3, t: '시작 시각\n비워 둘 수 있음' },
      { n: 4, t: '종료 시각\n비워 둘 수 있음' },
      { n: 5, t: '작업 구간 안내\n이 안이어야 함' },
      { n: 6, t: '[추가]로 저장' },
    ],
    { x: 7.2, y: 1.2, w: 2.3, gap: 0.52, fontSize: 11, dark: true },
  );

  addBadge(slide, pres, theme, 9);
  return slide;
}

module.exports = { createSlide, slideConfig };
