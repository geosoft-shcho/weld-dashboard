const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = {
  type: 'content',
  index: 13,
  title: '문서·이미지 올리기',
};

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };

  slide.addText('7-2. 파일 종류 — 문서·이미지', {
    x: 0.35,
    y: 0.1,
    w: 9.2,
    h: 0.28,
    fontSize: 16,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  slide.addText(
    'pdf·jpg·png를 고르면 시간 0 시각이 필수가 아닙니다. 후처리 안내도 종류에 맞게 바뀝니다.',
    {
      x: 0.35,
      y: 0.38,
      w: 9.2,
      h: 0.24,
      fontSize: 11,
      fontFace: 'Arial',
      color: theme.secondary,
      margin: 0,
    },
  );

  slide.addImage({
    path: img('11-upload-pdf-n.png'),
    x: 0.3,
    y: 0.68,
    w: 6.55,
    h: 4.1,
  });

  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x: 7.05,
    y: 0.68,
    w: 2.6,
    h: 4.1,
    fill: { color: 'FFFFFF' },
    rectRadius: 0.08,
  });
  slide.addText('번호 안내', {
    x: 7.2,
    y: 0.85,
    w: 2.3,
    h: 0.26,
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
        t: '종류 짐작\npdf → 문서·성적서\njpg·png → 이미지',
      },
      {
        n: 2,
        t: '올린 뒤 후처리\npdf: 속성 →\n글자 인식·성적서\n이미지: 속성만',
      },
      {
        n: 3,
        t: '시간 0의 시각\n필수 표시(*) 없음\n비워도 올릴 수 있음',
      },
    ],
    { x: 7.2, y: 1.25, w: 2.3, gap: 0.95, fontSize: 11 },
  );

  addBadge(slide, pres, theme, 13);
  return slide;
}

module.exports = { createSlide, slideConfig };
