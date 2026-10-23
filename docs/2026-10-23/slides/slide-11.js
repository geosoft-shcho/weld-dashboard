const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 11, title: '에셋 올리기' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('7. 첨부 — 에셋 올리기 창', {
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
    '첨부 탭에서 [에셋 올리기]를 누르면 열립니다. 파일을 고르면 안내가 바뀌며, 다음 두 장에서 종류별로 봅니다.',
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
    path: img('10-asset-upload-n.png'),
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
      { n: 1, t: '파일 고르기\n고르면 종류 안내·\n후처리 안내가 뜸' },
      { n: 2, t: '작업\n(이 작업으로 고정)' },
      { n: 3, t: '패스\n또는 작업 공용' },
      { n: 4, t: '장비 (선택)' },
      { n: 5, t: '시간 0의 시각\n시간 자료면 필수 *' },
      { n: 6, t: '[올리기]' },
    ],
    { x: 7.2, y: 1.2, w: 2.3, gap: 0.52, fontSize: 11, dark: true },
  );
  addBadge(slide, pres, theme, 11);
  return slide;
}

module.exports = { createSlide, slideConfig };
