const pptxgen = require('pptxgenjs');
const path = require('path');
const fs = require('fs');

const pres = new pptxgen();
pres.layout = 'LAYOUT_16x9';
pres.author = 'weld-dashboard';
pres.title = '작업 등록 매뉴얼';

const theme = {
  primary: '264653',
  secondary: '2a9d8f',
  accent: 'e76f51',
  light: 'e9c46a',
  bg: 'f7f5f0',
};

for (let i = 1; i <= 15; i++) {
  const num = String(i).padStart(2, '0');
  require(`./slide-${num}.js`).createSlide(pres, theme);
}

const outPath = path.join(__dirname, 'output', '작업_등록_매뉴얼.pptx');
const rootPath = path.join(__dirname, '..', '작업_등록_매뉴얼.pptx');

pres.writeFile({ fileName: outPath }).then(() => {
  fs.copyFileSync(outPath, rootPath);
  console.log('Wrote', outPath);
  console.log('Copied', rootPath);
});
