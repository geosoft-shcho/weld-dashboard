---
name: document-export
description: >-
  PPT, PPTX, PowerPoint, 슬라이드, 발표자료, PDF, DOCX, 매뉴얼, 안내 문서를
  만들거나 고칠 때 마크다운을 먼저 쓰고, 검수 스냅샷을 확인받은 뒤에만
  docs/manuals 변환 스크립트로 pdf·pptx·docx를 만든다.
  슬라이드 디자인은 pptx-generator 스킬을 따른다.
  관객과 톤은 요청마다 확인하고, 문장은 휴먼체로 쓴다.
---

# 문서 작성·변환

발표·안내 문서는 마크다운이 원본이다. PDF, PPTX, DOCX는 `docs/manuals` 변환 스크립트가 만든다. 슬라이드 장 구성과 16:9 레이아웃은 `.agents/skills/pptx-generator/SKILL.md`를 따른다. 그 스킬의 `slides/slide-NN.js`를 새로 만들어 PPTX를 직접 쓰지 않는다. 이미 있는 PPTX를 XML로 고치는 요청만 pptx-generator의 편집 절차를 쓴다.

## 적용

적용:

- PPT, PPTX, PowerPoint, 슬라이드, 발표자료, 덱
- PDF, DOCX, 매뉴얼, 안내 문서, 교육 자료

적용하지 않음:

- 화면·위젯·Dart 구현 (work-prompt, apply-guidelines)
- 커밋·푸시

## 진행

순서를 건너뛰지 않는다.

1. **관객을 묻는다.** 문서를 쓰기 전에 누구를 위한 글인지 확인한다. 사용자가 이미 골랐으면 다시 묻지 않는다.
   - IT 회사 내부 임직원
   - 현장 작업 관리자
2. **톤을 고른다.** 원본 마크다운은 바꾸지 않고 `docs/manuals/tones/<id>.json`만 바꾼다. 이번 요청의 톤을 적고, 다르면 그 파일을 만들거나 고친다. 기본 후보는 관객에 맞춘다.
   - 현장 작업 관리자 → `field` (짧고, 버튼 이름 그대로)
   - IT 회사 내부 임직원 → `formal` (절차가 분명한 공유용). 짧게 보면 `brief`
3. **마크다운을 쓴다.** `docs/manuals/sources/<이름>.md`만 고친다. `##` 하나가 슬라이드 한 장이다. 이미지는 `![설명](상대경로)`로 넣는다. 문장은 휴먼체다.
4. **검수 스냅샷만 만든다.** 제품용 PDF·PPTX·DOCX는 아직 만들지 않는다.

```bash
cd docs/manuals
npm install
node scripts/build.mjs --source <이름> --tone <톤> --format md
```

스냅샷은 `docs/manuals/output/<이름>__<톤>/<이름>.md`이다. 사용자에게 그 경로와 `##` 장 목록을 보여주고 검수를 기다린다.
5. **검수 후에만 변환한다.** 사용자가 스냅샷을 확인하면 요청한 형식으로 변환한다. 형식을 말하지 않았으면 `all`이다.

```bash
node scripts/build.mjs --source <이름> --tone <톤> --format all
```

결과는 `docs/manuals/output/<이름>__<톤>/`의 md, docx, pptx, pdf이다. PDF는 Chromium이 있을 때만 생긴다.

톤만 바꿀 때는 원본을 다시 쓰지 않는다. `--tone`만 바꿔 4번부터 다시 한다.

## 휴먼체

읽는 사람이 회의에서 말하듯 쓴다.

- 화면 이름, 버튼 이름, 다음에 할 행동을 적는다.
- 한 문장에 할 일 하나만 둔다.
- 관객이 모르는 약어는 처음 한 번 풀어 쓴다.
- "종합하면", "주목할 점은", "시사점", "결론적으로"처럼 문서가 스스로를 설명하는 말은 쓰지 않는다.

## 슬라이드

`.agents/skills/pptx-generator/SKILL.md`의 장 종류(표지, 목차, 구분, 본문, 요약)를 `##` 제목으로 나눈다. 같은 꼴의 장만 반복하지 않는다. 변환 스크립트가 16:9와 Arial로 PPTX를 만든다. 장 번호 배지와 색은 스크립트 출력을 따른다.

## 고치지 않는 것

- `docs/manuals/scripts/build.mjs`는 변환이 깨졌을 때만 고친다.
- pptx-generator 저장소 절차로 `slides/slide-NN.js` 덱을 병행 생성하지 않는다.
