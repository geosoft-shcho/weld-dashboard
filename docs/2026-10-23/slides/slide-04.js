const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 4, title: '작업 관리 화면' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('1. 작업 관리 화면', {
    x: 0.35,
    y: 0.15,
    w: 6,
    h: 0.3,
    fontSize: 20,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  slide.addText('화면의 번호와 오른쪽 설명을 같이 보세요.', {
    x: 0.35,
    y: 0.45,
    w: 6,
    h: 0.22,
    fontSize: 12,
    fontFace: 'Arial',
    color: theme.secondary,
    margin: 0,
  });
  slide.addImage({
    path: img('01-work-history-n.png'),
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
    y: 0.95,
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
      { n: 1, t: '왼쪽 [작업 관리] 메뉴' },
      { n: 2, t: '[조회] — 목록 불러오기' },
      { n: 3, t: '[새 작업] — 새로 등록' },
      { n: 4, t: '[상세] — 작업 내용 열기' },
      { n: 5, t: '[프로파일] — 파형 보기' },
      { n: 6, t: '[품질] — 품질 결과 보기' },
    ],
    { x: 7.2, y: 1.4, w: 2.3, gap: 0.5, fontSize: 12 },
  );
  addBadge(slide, pres, theme, 4);
  return slide;
}

module.exports = { createSlide, slideConfig };
