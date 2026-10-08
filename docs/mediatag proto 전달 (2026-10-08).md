# mediatag proto 전달 (2026-10-08)

기준: mediatag `main` 3841319. 서버(http://192.168.100.3:33210)에 반영된 상태와 같다.

| 파일 | 내용 |
|---|---|
| `1_ID 변경 안내.md` | 먼저 볼 것. 기존 화면을 고쳐야 하는 변경(ID가 숫자로) |
| `2_만들기·고치기·지우기와 업로드 추가 안내.md` | 새 기능. 기존 화면에는 영향 없음 |
| `proto/mediatag/` | `work`·`asset`·`compose`·`report`·`tool` proto |
| `참고문서/` | 자세한 설명 |

proto의 import 기준 폴더는 `proto/`이다(`mediatag/asset/v1/asset.proto`를 서로 import한다).
