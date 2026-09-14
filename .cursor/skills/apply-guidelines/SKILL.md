---
name: apply-guidelines
description: >-
  https://github.com/geosoft-co-kr/guidelines.git 를 워킹 트리 밖에서 먼저 읽은 뒤,
  그 규칙에 맞게 Flutter 페이지·화면·위젯·ViewModel·Coordinator·도메인/데이터 코드를 생성한다.
  앱 기능, UI, 페이지, 화면, 위젯, 네이밍, 폴더 구조, Dart/Flutter 코드를 구현하거나 수정할 때 사용한다.
---

# 코딩 가이드라인 적용

기준 레포는 https://github.com/geosoft-co-kr/guidelines.git 이다. Dart를 쓰거나 고치기 **전에** 해당 문서를 읽는다. 백그라운드에서 한다. 확인할지 사용자에게 묻지 않고, 사용자가 요청하지 않으면 가이드라인 본문을 답변에 붙여 넣지 않는다.

가이드라인 저장소는 **읽기 전용**이다. 파일을 수정·편집하지 않는다. weld-dashboard 워킹 트리(`docs/guidelines` 포함)에 클론하거나 복사하지 않는다.

## 필수

이 턴에서 관련 가이드라인을 읽기 전에는 `lib/**`의 기능·페이지·위젯 코드를 만들거나 수정하지 않는다. 같은 대화에서 같은 종류의 작업을 위해 이미 읽었다면 다시 읽지 않아도 된다.

가이드라인과 일상적인 요청이 충돌하면 가이드라인을 따른다. 가이드라인 문서끼리 충돌하면 **기본 코딩 가이드라인**이 Flutter 전용 문서보다 우선한다.

## 절차

1. 워킹 트리 밖 임시 디렉터리에 `--depth 1`로 클론한다. 프로젝트 폴더 안은 금지.
2. 임시 트리에서 `**/*.md`를 glob한다. 문서 트리는 늘어날 수 있으므로 아래 표만 믿지 않는다.
3. 표에서 파일을 고른다. 새 페이지·위젯·기능이면 두 Intro와 폴더 구조 문서는 항상 포함한다.
4. 해당 파일을 읽은 뒤 구현한다. 이름, 경로, 계층 경계를 읽은 내용에 맞춘다.
5. 패턴이 필요하면 `3. Example.md`는 구조만 참고한다. 로그인 데모를 제품에 복사하지 않는다.
6. 구현이 끝나면 임시 클론을 삭제한다.

```bash
tmp=$(mktemp -d /tmp/weld-guidelines.XXXXXX)
git clone --depth 1 https://github.com/geosoft-co-kr/guidelines.git "$tmp"
# "$tmp"에서 문서를 읽는다
rm -rf "$tmp"
```

## 파일 맵 (가이드라인 레포 루트)

| 언제 | 읽을 파일 |
|------|-----------|
| 페이지, 화면, 위젯, 기능, Dart 전반 | `코딩/1. 기본 코딩 가이드라인/1. Intro.md` |
| 위와 같음 | `코딩/2. flutter 코딩 가이드라인/1. Intro.md` |
| 파일 추가·이동, 기능 폴더 배치 | `코딩/2. flutter 코딩 가이드라인/2. 프로젝트 폴더 구조.md` |
| 새 기능 / MVVM-C 연결 | `코딩/2. flutter 코딩 가이드라인/3. Example.md` |
| Boolean·형용사 이름 | `코딩/1. 기본 코딩 가이드라인/형용사 관련 분석.md` |
| 함수, 메서드 | `코딩/1. 기본 코딩 가이드라인/함수, 메서드 관련 분석.md` |
| 필드, 속성 | `코딩/1. 기본 코딩 가이드라인/변수, 속성 관련 분석.md` |
| 리스트, 맵, 셋 | `코딩/1. 기본 코딩 가이드라인/Collection 관련 분석.md` |
| 콜백, `on` / `handle` | `코딩/1. 기본 코딩 가이드라인/Event 관련 분석.md` |
| `id` / `code` / `name` / `index` | `코딩/1. 기본 코딩 가이드라인/단어 분류 관련 분석.md` |
| 이름에 타입 접두사 | `코딩/1. 기본 코딩 가이드라인/헝가리안 표기법.md` (**헝가리안 표기법은 쓰지 않는다**) |
| 시각·테마 문서가 있으면 | `스타일/**` |

없는 파일은 건너뛴다. 맞는 파일이 없으면 두 Intro와 가장 가까운 `.md`를 읽고 구현한다.

## 아키텍처 (폴더 구조 문서)

`lib/src/` 아래 기능 우선: `domain` → `data` → `presentation`.

- Domain: 순수 Dart. 엔티티, 저장소 **인터페이스**, 유스케이스. Flutter·gRPC·HTTP 의존 없음.
- Data: 도메인 저장소를 구현. DTO, 데이터소스. `toDomain()`. View/ViewModel에서 import하지 않는다.
- Presentation: View, ViewModel, Coordinator. ViewModel은 **유스케이스만** 호출한다. 내비게이션은 Coordinator가 맡는다. View는 Data나 UseCase를 직접 호출하지 않는다.

```
lib/src/presentation/features/<feature>/
  <feature>_screen.dart          # 파일이 적을 때
  <feature>_view_model.dart
  <feature>_coordinator.dart

  views/                         # 파일이 많을 때
  view_models/
```

공통 위젯: `lib/src/presentation/core/widgets/`. 앱 내비게이션: `lib/src/presentation/navigation/app_coordinator.dart`.

## 네이밍 (요약)

- 파일, 폴더, 패키지: `snake_case` (`login_screen.dart`).
- 타입: `UpperCamelCase` 명사 (`LoginScreen`, `LoginViewModel`).
- 멤버, 함수: `lowerCamelCase`. 함수는 동사 (`didTapLogin`, `fetchUsers`).
- 상수: `UPPERCASE_WITH_UNDERSCORES` (기본 가이드가 Flutter Intro의 lowerCamelCase 상수보다 우선).
- Bool: 형용사 / `is` / `has` / `can`. `isExist`는 쓰지 않고 `doesExist`.
- 컬렉션: 복수형 (`users`, `usersById`). `userList` / `userMap`은 쓰지 않는다.
- 이벤트: `on[Event]`, 핸들러 함수 `handle[Action]`, 콜백 필드 `[action]Handler`.
- 두 글자 약어: `ioService`. 세 글자 이상: `httpMethod` (`HTTPMethod` 금지).

## 생성 후

새 파일은 매핑된 경로에 둔다. 기능 위젯을 `lib/` 루트에 두지 않는다. Presentation에서 Data를 호출하지 않는다.
