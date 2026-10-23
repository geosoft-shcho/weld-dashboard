const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 7, title: '기본 정보' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('4. 작업 상세 — 기본 정보', {
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
  slide.addText('화면 번호와 오른쪽 설명을 같이 보세요.', {
    x: 0.35,
    y: 0.4,
    w: 7,
    h: 0.22,
    fontSize: 12,
    fontFace: 'Arial',
    color: theme.secondary,
    margin: 0,
  });
  slide.addImage({
    path: img('04-job-detail-info-n.png'),
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
      { n: 1, t: '작업 요약 카드' },
      { n: 2, t: '[기본 정보] 탭' },
      { n: 3, t: '[저장]' },
      { n: 4, t: '[작업 지우기]' },
      { n: 5, t: '공사·품목·시간 등\n입력 칸' },
      { n: 6, t: '프로파일·품질로\n바로 이동' },
    ],
    { x: 7.2, y: 1.3, w: 2.3, gap: 0.52, fontSize: 12 },
  );
  addBadge(slide, pres, theme, 7);
  return slide;
}

module.exports = { createSlide, slideConfig };
