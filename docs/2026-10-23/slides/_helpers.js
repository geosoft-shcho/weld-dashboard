const path = require('path');

function img(name) {
  return path.join(__dirname, 'imgs', name);
}

function addBadge(slide, pres, theme, page) {
  slide.addShape(pres.shapes.OVAL, {
    x: 9.3,
    y: 5.1,
    w: 0.4,
    h: 0.4,
    fill: { color: theme.accent },
  });
  slide.addText(String(page), {
    x: 9.3,
    y: 5.1,
    w: 0.4,
    h: 0.4,
    fontSize: 12,
    fontFace: 'Arial',
    color: 'FFFFFF',
    bold: true,
    align: 'center',
    valign: 'middle',
    margin: 0,
  });
}

/** 오른쪽에 번호+설명 목록을 그린다. */
function addNumberedNotes(slide, pres, theme, notes, opts) {
  const x = opts.x;
  const y0 = opts.y;
  const w = opts.w;
  const gap = opts.gap || 0.52;
  notes.forEach((note, i) => {
    const y = y0 + i * gap;
    slide.addShape(pres.shapes.OVAL, {
      x,
      y: y + 0.02,
      w: 0.28,
      h: 0.28,
      fill: { color: theme.accent },
    });
    slide.addText(String(note.n), {
      x,
      y: y + 0.02,
      w: 0.28,
      h: 0.28,
      fontSize: 11,
      fontFace: 'Arial',
      color: 'FFFFFF',
      bold: true,
      align: 'center',
      valign: 'middle',
      margin: 0,
    });
    slide.addText(note.t, {
      x: x + 0.36,
      y,
      w: w - 0.36,
      h: gap - 0.06,
      fontSize: opts.fontSize || 12,
      fontFace: 'Arial',
      color: opts.dark ? 'FFFFFF' : '4A5560',
      margin: 0,
    });
  });
}

module.exports = { img, addBadge, addNumberedNotes };
