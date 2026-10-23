const pptxgen = require('pptxgenjs');
const { addBadge, addNumberedNotes, img } = require('./_helpers');

const slideConfig = {
  type: 'content',
  index: 12,
  title: '시간 자료 올리기',
};

function createSlide(pres, theme) {
  const slide = pres.addSlide();
  slide.background = { color: theme.bg };

  slide.addText('7-1. 파일 종류 — 시간 자료(영상·음성·센서 등)', {
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
    'mp4·mkv·wav·csv 등을 고르면 아래처럼 안내와 필수 칸이 바뀝니다. 화면의 번호와 오른쪽 설명을 같이 보세요.',
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
    path: img('11-upload-video-n.png'),
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
    fill: { color: theme.primary },
    rectRadius: 0.08,
  });
  slide.addText('번호 안내', {
    x: 7.2,
    y: 0.85,
    w: 2.3,
    h: 0.26,
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
        t: '종류 짐작\n확장자로 안내.\n최종은 서버가\n내용으로 판별',
      },
      {
        n: 2,
        t: '올린 뒤 후처리\n영상 예:\n속성 → 길이 →\n타임라인 배치',
      },
      {
        n: 3,
        t: '시간 0의 시각 *\n시간 자료는 필수.\n없으면 올릴 수 없음',
      },
      {
        n: 4,
        t: '빠른 채우기\n패스·작업 시작,\n파일·현재 시각',
      },
    ],
    { x: 7.2, y: 1.2, w: 2.3, gap: 0.82, fontSize: 11, dark: true },
  );

  addBadge(slide, pres, theme, 12);
  return slide;
}

module.exports = { createSlide, slideConfig };
