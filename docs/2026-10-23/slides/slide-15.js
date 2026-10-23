const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = { type: 'content', index: 15, title: '품질' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };

  slide.addText('9. 품질 화면', {
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
    '목록의 [품질] 또는 작업 상세의 [품질 이슈]로 엽니다. 성적서와 파형을 같은 패스 기준으로 함께 봅니다.',
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
    path: img('09-quality-issue-n.png'),
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
      {
        n: 1,
        t: '패스 선택\nP1, P2…를 바꿔\n패스별 결과를 봅니다',
      },
      {
        n: 2,
        t: '성적서 · 문서\nPDF·영상 등\n품질 자료를 봅니다',
      },
      {
        n: 3,
        t: '파형\n같은 패스의\n전류·전압 등을 봅니다',
      },
    ],
    { x: 7.2, y: 1.35, w: 2.3, gap: 1.05, fontSize: 11, dark: true },
  );

  addBadge(slide, pres, theme, 15);
  return slide;
}

module.exports = { createSlide, slideConfig };
