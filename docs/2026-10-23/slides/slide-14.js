const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 14, title: '프로파일' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };

  slide.addText('8. 프로파일 화면', {
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
    '목록의 [프로파일] 또는 작업 상세의 [프로파일]로 엽니다. 패스마다 전류·전압 등 파형을 봅니다.',
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
    path: img('08-pass-profile-n.png'),
    x: 0.3,
    y: 0.72,
    w: 6.55,
    h: 4.1,
  });

  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x: 7.05,
    y: 0.72,
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
      {
        n: 1,
        t: '작업 요약 카드\n공사·품목·작업자·\n장비를 한눈에 봅니다',
      },
      {
        n: 2,
        t: '패스 선택\nP1, P2…를 바꿔\n패스별 파형을 봅니다',
      },
      {
        n: 3,
        t: '파형 차트\n전류·전압·속도 등을\n시간 흐름으로 봅니다',
      },
    ],
    { x: 7.2, y: 1.35, w: 2.3, gap: 1.05, fontSize: 11 },
  );

  addBadge(slide, pres, theme, 14);
  return slide;
}

module.exports = { createSlide, slideConfig };
