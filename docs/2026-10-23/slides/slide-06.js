const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 6, title: '목록에서 화면 열기' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('3. 목록에서 상세 · 프로파일 · 품질 열기', {
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
    '새 작업을 만들면 목록이 그 작업에 맞춰집니다. 기존 작업도 같은 버튼으로 엽니다.',
    {
      x: 0.35,
      y: 0.42,
      w: 9.2,
      h: 0.24,
      fontSize: 12,
      fontFace: 'Arial',
      color: theme.secondary,
      margin: 0,
    },
  );
  slide.addImage({
    path: img('06-list-actions-n.png'),
    x: 0.3,
    y: 0.75,
    w: 6.55,
    h: 4.1,
  });
  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x: 7.05,
    y: 0.75,
    w: 2.6,
    h: 4.1,
    fill: { color: 'FFFFFF' },
    rectRadius: 0.08,
  });
  slide.addText('번호 안내', {
    x: 7.2,
    y: 1.0,
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
      { n: 1, t: '[상세]\n기본 정보·패스·첨부를\n고치고 정리합니다' },
      { n: 2, t: '[프로파일]\n패스별 전류·전압 등\n파형을 봅니다' },
      { n: 3, t: '[품질]\n품질 결과와 파형을\n함께 봅니다' },
    ],
    { x: 7.2, y: 1.5, w: 2.3, gap: 1.0, fontSize: 12 },
  );
  addBadge(slide, pres, theme, 6);
  return slide;
}

module.exports = { createSlide, slideConfig };
