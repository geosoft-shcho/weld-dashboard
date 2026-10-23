const pptxgen = require('pptxgenjs');
const { addBadge } = require('./_helpers');

const slideConfig = { type: 'content', index: 3, title: '전체 순서' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('전체 순서', {
    x: 0.5,
    y: 0.28,
    w: 8,
    h: 0.4,
    fontSize: 28,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  slide.addText('왼쪽 메뉴의 [작업 관리]에서 시작해, 아래 순서로 진행합니다.', {
    x: 0.5,
    y: 0.72,
    w: 9,
    h: 0.28,
    fontSize: 13,
    fontFace: 'Arial',
    color: theme.secondary,
    margin: 0,
  });
  const steps = [
    { n: '1', t: '작업 관리', d: '새 작업을 만들거나\n기존 작업을 고릅니다' },
    { n: '2', t: '작업 상세', d: '기본 정보·패스·첨부를\n확인하고 정리합니다' },
    { n: '3', t: '조회 화면', d: '프로파일·품질로\n같은 작업을 살펴봅니다' },
  ];
  steps.forEach((s, i) => {
    const x = 0.5 + i * 3.1;
    slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
      x,
      y: 1.3,
      w: 2.85,
      h: 2.5,
      fill: { color: 'FFFFFF' },
      rectRadius: 0.08,
    });
    slide.addShape(pres.shapes.OVAL, {
      x: x + 1.05,
      y: 1.55,
      w: 0.7,
      h: 0.7,
      fill: { color: i === 1 ? theme.primary : theme.secondary },
    });
    slide.addText(s.n, {
      x: x + 1.05,
      y: 1.55,
      w: 0.7,
      h: 0.7,
      fontSize: 22,
      fontFace: 'Arial',
      color: 'FFFFFF',
      bold: true,
      align: 'center',
      valign: 'middle',
      margin: 0,
    });
    slide.addText(s.t, {
      x: x + 0.2,
      y: 2.45,
      w: 2.45,
      h: 0.35,
      fontSize: 18,
      fontFace: 'Arial',
      color: theme.primary,
      bold: true,
      align: 'center',
      margin: 0,
    });
    slide.addText(s.d, {
      x: x + 0.2,
      y: 2.9,
      w: 2.45,
      h: 0.7,
      fontSize: 13,
      fontFace: 'Arial',
      color: '4A5560',
      align: 'center',
      margin: 0,
    });
    if (i < 2) {
      slide.addShape(pres.shapes.RIGHT_ARROW, {
        x: x + 2.88,
        y: 2.4,
        w: 0.2,
        h: 0.25,
        fill: { color: theme.accent },
      });
    }
  });
  slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
    x: 0.5,
    y: 4.15,
    w: 8.8,
    h: 0.6,
    fill: { color: 'FFFFFF' },
    rectRadius: 0.06,
  });
  slide.addText(
    '한 줄 요약  ·  작업을 먼저 잡고 → 패스와 자료를 정리한 뒤 → 같은 작업으로 조회합니다.',
    {
      x: 0.7,
      y: 4.28,
      w: 8.4,
      h: 0.35,
      fontSize: 13,
      fontFace: 'Arial',
      color: theme.primary,
      margin: 0,
    },
  );
  addBadge(slide, pres, theme, 3);
  return slide;
}

module.exports = { createSlide, slideConfig };
