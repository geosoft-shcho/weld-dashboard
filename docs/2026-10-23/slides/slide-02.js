const pptxgen = require('pptxgenjs');
const { addBadge } = require('./_helpers');

const slideConfig = { type: 'toc', index: 2, title: '목차' };

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };
  slide.addText('목차', {
    x: 0.5,
    y: 0.35,
    w: 8,
    h: 0.45,
    fontSize: 30,
    fontFace: 'Arial',
    color: theme.primary,
    bold: true,
    margin: 0,
  });
  const items = [
    ['01', '전체 순서', '작업 관리 → 작업 상세 → 조회'],
    ['02', '작업 관리 화면', '목록에서 찾고, 새 작업을 만듭니다'],
    ['03', '새 작업 만들기', '작업과 패스를 한 번에 등록'],
    ['04', '상세 · 프로파일 · 품질', '목록과 작업 상세에서 화면을 엽니다'],
    ['05', '작업 상세 정리', '기본 정보 · 패스 추가 · 첨부 · 올리기'],
    ['06', '파일 종류별 올리기', '시간 자료 vs 문서·이미지 화면'],
    ['07', '프로파일 · 품질 보기', '파형과 성적서를 패스 단위로 확인'],
  ];
  items.forEach((item, i) => {
    const y = 0.9 + i * 0.52;
    slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
      x: 0.5,
      y,
      w: 9,
      h: 0.46,
      fill: { color: 'FFFFFF' },
      rectRadius: 0.05,
    });
    slide.addText(item[0], {
      x: 0.7,
      y: y + 0.08,
      w: 0.65,
      h: 0.3,
      fontSize: 15,
      fontFace: 'Arial',
      color: theme.accent,
      bold: true,
      margin: 0,
    });
    slide.addText(item[1], {
      x: 1.45,
      y: y + 0.02,
      w: 7.7,
      h: 0.22,
      fontSize: 13,
      fontFace: 'Arial',
      color: theme.primary,
      bold: true,
      margin: 0,
    });
    slide.addText(item[2], {
      x: 1.45,
      y: y + 0.22,
      w: 7.7,
      h: 0.2,
      fontSize: 11,
      fontFace: 'Arial',
      color: theme.secondary,
      margin: 0,
    });
  });
  addBadge(slide, pres, theme, 2);
  return slide;
}

module.exports = { createSlide, slideConfig };
