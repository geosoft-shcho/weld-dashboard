# weld-dashboard — 에이전트 지도

이 파일은 **개발용 코딩 에이전트(A축)** 용이다. 제품 안 LLM 에이전트(B축) 설계 문서가 아니다.

## 목적

멀티모달 수집값(시계열·영상·음성·품질)을 같은 작업 시각 기준으로 가시화한다. 공정 전용 UI로 고정하지 않는다.

## 스택

- Flutter / Dart (Web 포함)
- MediaTag Connect (`WorkService`, `AssetService`)
- 생성 코드: `lib/src/data/datasources/generated/` (직접 수정하지 않음)

## 검증

```bash
./scripts/agent_check.sh
./scripts/agent_check.sh test/<관련>_test.dart
```

인자 없으면 `dart analyze`만. 인자가 있으면 analyze 후 해당 `flutter test` 경로.

## 기능 구현 파이프

1. Ask — 읽기·분석만
2. Plan — 작업 프롬프트 계획, 사용자 확인
3. `docs/<YYYY-MM-DD>/<작업>_프롬프트.md` 저장
4. Agent — 그 문서만 구현
5. `./scripts/agent_check.sh` + 구현 후 검수
6. 커밋·푸시는 사용자 요청 시에만

확인된 프롬프트와 계획이 없으면 제품 코드를 고치지 않는다.

## 코딩 가이드라인

https://github.com/geosoft-co-kr/guidelines.git 는 **워킹 트리 밖**에서 `--depth 1`로 읽어만 본다. 이 레포에 클론·복사·커밋하지 않는다. 절차는 `.cursor/skills/apply-guidelines/SKILL.md`.

## 금지 요지

- 프롬프트 범위 밖 리팩터·이름 정리·스타일 통일
- 한 동작을 위한 새 추상 계층·전략·팩토리·제네릭 헬퍼
- 새 상태관리·디자인 시스템·카드 UI 도입
- `.env`, 자격 증명, 키, 비밀 파일 커밋
- 요청 없는 커밋·푸시

## 상세

| 주제 | 위치 |
|------|------|
| 절차·검수·회고 | `.cursor/skills/work-prompt/SKILL.md` |
| 방식 설명 | `docs/2026-11-03/Cursor_에이전트_기능구현_방식.md` |
| Flutter 배치·네이밍 | `.cursor/skills/apply-guidelines/SKILL.md` |
| 커밋·푸시 | `.cursor/skills/git-commit-push/SKILL.md` |
| Cursor always-on | `.cursor/rules/*.mdc` |
