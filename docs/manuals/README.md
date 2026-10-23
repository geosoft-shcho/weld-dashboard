# 매뉴얼 문서 (마크다운 원본 → 변환)

용접 수집 관계자가 읽는 안내 문서는 **마크다운을 원본**으로 두고, 필요할 때 PDF · PPTX · DOCX로 변환합니다.

## 폴더

| 경로 | 역할 |
|---|---|
| `sources/` | 마크다운 원본 (사람이 고치는 곳) |
| `tones/` | 말투·호칭 프리셋 (그때그때 바꿈) |
| `scripts/` | 변환 스크립트 |
| `assets/` | 공통 이미지 (선택) |
| `output/` | 변환 결과물 |

화면 캡처는 기존 경로 `docs/2026-10-23/slides/imgs/`를 그대로 참조합니다.

## 한 줄로 만들기

```bash
cd docs/manuals
npm install
node scripts/build.mjs --source 작업_등록_매뉴얼 --tone field --format all
```

| 옵션 | 예 | 뜻 |
|---|---|---|
| `--source` | `작업_등록_매뉴얼` | `sources/<이름>.md` |
| `--tone` | `field` · `formal` · `brief` | `tones/<이름>.json` |
| `--format` | `all` · `md` · `docx` · `pptx` · `pdf` | 출력 형식 |

## 톤을 바꾸는 방법

1. `tones/`에 JSON을 하나 더 만들거나 기존 파일을 고칩니다.
2. 빌드할 때 `--tone`만 바꿉니다. 원본 마크다운은 그대로 둡니다.

톤 파일에 넣는 값:

- `audience` — 누구를 위한 문서인지
- `voice` — 말투 한 줄 설명
- `cover_kicker` — 표지 윗줄
- `cover_lead` — 표지·서문 첫 문단
- `section_lead` — 각 장 앞에 붙는 짧은 안내(비우면 생략). PPTX는 제목 아래 설명을 넣지 않음
- `phrases` — 문장 치환 (`찾기` → `바꾸기`)

## 원본을 고칠 때

1. `sources/*.md`만 수정합니다.
2. 슬라이드/절은 `##` 제목 단위입니다. PPTX는 `##`마다 한 장으로 나눕니다.
3. 이미지는 `![설명](상대경로)`로 넣습니다.
4. 번호 안내는 목록으로 적습니다. 캡처에 붙인 번호와 맞춥니다.

## 결과물

`output/<소스>__<톤>/` 아래에 생성됩니다.

- `작업_등록_매뉴얼.md` — 톤이 적용된 마크다운
- `작업_등록_매뉴얼.docx`
- `작업_등록_매뉴얼.pptx`
- `작업_등록_매뉴얼.pdf` (가능하면)

PDF는 로컬에 Chromium(Playwright)이 있으면 HTML 인쇄로 만듭니다. 없으면 DOCX·PPTX만 만들고 PDF는 건너뜁니다.
