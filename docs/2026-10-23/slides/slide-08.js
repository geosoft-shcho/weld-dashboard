const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 8, title: '패스' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('5. 작업 상세 — 패스', {
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
    '패스는 조회할 때 나누는 시간 단위입니다. [+ 패스 추가] 창은 다음 장에서 봅니다.',
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
    path: img('05-job-detail-pass-n.png'),
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
      { n: 1, t: '[+ 패스 추가]' },
      { n: 2, t: '패스 목록\n(시작·종료)' },
      { n: 3, t: '수정 · 지우기\n아이콘' },
      { n: 4, t: '구간 규칙 안내\n(겹침 불가)' },
    ],
    { x: 7.2, y: 1.4, w: 2.3, gap: 0.7, fontSize: 12, dark: true },
  );
  addBadge(slide, pres, theme, 8);
  return slide;
}

module.exports = { createSlide, slideConfig };
