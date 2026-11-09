# GetClip pending/캐시 상세 가드

## 목표
GetClip 네트워크 진행 중에 캐시된 다른 클립을 고르면, 남아 있던 pending GetClip이 나중에 Properties·스테이지를 덮지 않게 한다. 최종 선택 클립의 상세만 반영한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`_loadClipDetail`, `_fetchClipDetailNetwork`, `_pendingClipDetailId`)
4. 계약·화면안: 없음

## 현재 상태
- 네트워크 busy일 때 미스만 `_pendingClipDetailId`에 latest-wins로 쌓인다.
- 캐시 히트는 busy와 무관히 즉시 적용하지만 pending을 비우지 않는다.
- busy 루프가 끝난 뒤 pending을 drain하면, 선택이 이미 다른(캐시) 클립이어도 그 상세를 적용할 수 있다(로그: side `18534`인데 `18551` apply로 필드 44→50).

## 바꿀 것
1. `_loadClipDetail` 캐시 히트 시: `_pendingClipDetailId = null`로 남아 있던 네트워크 대기를 취소한다.
2. `_fetchClipDetailNetwork`에서 상세를 Properties/스테이지에 넣기 직전: `detail.clipId != _selectedClipId`이면 apply하지 않고 stale와 같이 로그 후 return(로딩 플래그는 선택이 이 clip이 아니면 건드리지 않음; 선택과 같으면 기존대로 loading false).
3. drain 루프에서 pending이 `_selectedClipId`와 다르면 fetch/apply하지 않고 건너뛴다(pending clear만).

## 유지할 것
- GetClip 동시 상한 1, latest pending 큐
- epoch stale 가드, Properties 요약 즉시 표시
- ClipDetailCache

## 이번 작업에서 만들지 않음
- 타임라인 탭 잠금, include 축소, 서버/프록시
- 새 큐 클래스

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과 (`dart analyze`)
- 관련 테스트가 있으면 `./scripts/agent_check.sh`에 해당 경로 포함 통과
- GetClip 중 캐시 클립으로 옮기면 pending이 비워지고, 이후 다른 clipId 상세가 Properties에 덮이지 않음
- 순수 연타(latest pending) 동작은 유지
