const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 10, title: '첨부' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('6. 작업 상세 — 첨부', {
    x: 0.35,
    y: 0.12,
    w: 7,
    h: 0.28,
    fontSize: 18,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  slide.addText(
    '자료를 올리고, 붙이고, 패스를 지정합니다. [에셋 올리기] 창은 다음 장에서 봅니다.',
    {
      x: 0.35,
      y: 0.4,
      w: 9,
      h: 0.22,
      fontSize: 12,
      fontFace: 'Arial',
      color: theme.secondary,
      margin: 0,
    },
  );
  slide.addImage({
    path: img('06-job-detail-attach-n.png'),
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
    fill: { color: 'FFFFFF' },
    rectRadius: 0.08,
  });
  slide.addText('번호 안내', {
    x: 7.2,
    y: 0.9,
    w: 2.3,
    h: 0.28,
    fontSize: 13,
    fontFace: 'Arial',
    color: theme.accent,
    bold: true,
    margin: 0,
  });
  addNumberedNotes(
    slide,
    pres,
    theme,
    [
      { n: 1, t: '[에셋 올리기]\n새 파일 올리기' },
      { n: 2, t: '[에셋 붙이기]\n기존 자료 연결' },
      { n: 3, t: '패스 칸\n어느 패스에 속할지' },
      { n: 4, t: '연결 끊기\n(파일은 남음)' },
    ],
    { x: 7.2, y: 1.35, w: 2.3, gap: 0.75, fontSize: 12 },
  );
  addBadge(slide, pres, theme, 10);
  return slide;
}

module.exports = { createSlide, slideConfig };
