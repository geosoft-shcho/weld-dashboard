const pptxgen = require('pptxgenjs');

const slideConfig = { type: 'cover', index: 1, title: '작업 등록 매뉴얼' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.primary };
  slide.addShape(pres.shapes.RECTANGLE, {
    x: 0,
    y: 0,
    w: 0.18,
    h: 5.625,
    fill: { color: theme.accent },
  });
  slide.addText('용접 수집 대시보드', {
    x: 0.7,
    y: 1.4,
    w: 8.5,
    h: 0.35,
    fontSize: 14,
    fontFace: 'Arial',
    color: theme.light,
    margin: 0,
  });
  slide.addText('작업 등록 매뉴얼', {
    x: 0.7,
    y: 1.9,
    w: 8.5,
    h: 0.85,
    fontSize: 42,
    fontFace: 'Arial',
    color: 'FFFFFF',
    bold: true,
    margin: 0,
  });
  slide.addText(
    '새 작업을 만들고, 패스와 자료를 정리한 뒤\n프로파일·품질 화면으로 이어 보는 순서 안내',
    {
      x: 0.7,
      y: 2.95,
      w: 8.2,
      h: 0.8,
      fontSize: 16,
      fontFace: 'Arial',
      color: 'D9E2E5',
      margin: 0,
    },
  );
  slide.addText('2026-10-23  ·  화면 캡처 기준', {
    x: 0.7,
    y: 4.55,
    w: 8,
    h: 0.3,
    fontSize: 13,
    fontFace: 'Arial',
    color: theme.secondary,
    margin: 0,
  });
  return slide;
}

module.exports = { createSlide, slideConfig };
