# 구현 프롬프트 — playhead `T` 시계 파일 분리 (1차·2차) + 간소화

기준: `docs/2026-10-28/단일_playhead_T_클립끝_후_진행_프롬프트.md` (이미 반영된 §6 동작 유지)  
대상: `lib/src/presentation/features/video_multimodal/`  
참고 패턴: `video_playback_rate.dart`, `video_overlay_clock.dart`  
앱 목적: README — 같은 작업 시각. 구현 전 guidelines 스킬로 워킹 트리 밖 가이드라인 읽기.  
요청 없으면 커밋하지 말 것. guidelines 레포는 워킹 트리에 두지 말 것.

---

## 목적

단일 playhead `T` 재생 시계 로직을 ViewModel에서 빼 **읽기 쉬운 파일**로 두고,  
seek·배속 계산(2차)도 헬퍼로 모아 ViewModel을 얇게 한다.

**동작은 바꾸지 않는다.** 리팩터·간소화만.  
복잡한 분기·죽은 코드·이중 상태를 제거하고, 이름이 역할을 말하게 한다.

---

## 비범위

- covering / 모니터 포커스 / `_activeVideoClip` 해석을 시계 파일로 옮기기 (ViewModel 유지)
- P1 소스 막대·자르기·kind 뷰어
- proto/서버 변경
- 동작 변경(클립 끝 후에도 `T`→span, 파일로 `T` 덮지 않음 등은 **현행 유지**)

---

## 필독

- `video_multimodal_view_model.dart` — playhead 필드·`didReceiveVideoClock`·`didSeekToSeconds`·`didTapTogglePlayback`·`_syncPlayheadClock`~`_stopPlaybackAtTimelineEnd`·`fileSeekMilliseconds`·`playbackRateFor`
- `video_playback_rate.dart`, `clip_file_position.dart`
- `multimodal_video_stage.dart` (seekToken / wantsPlayback / onClock)
- 가이드 §6·§6.2 (동작 회귀 기준)

---

## 1차 — `T` 틱 엔진만 분리

### 만들 파일

`lib/src/presentation/features/video_multimodal/timeline_playhead_clock.dart`

**책임 (이것만):**
- `playheadSeconds` 보관·갱신
- `timelinePlaybackRate` (세션, 저장 안 함) + 배율 순환 값 목록
- `wantsPlayback` / 재생 중 여부(UI용 `isPlaying`에 대응하는 단순 플래그)
- wall × rate 틱 타이머 start/stop/dispose
- `spanSeconds`에 clamp; **span 끝에서만** 재생 종료 콜백
- 배율 사이클 (`0.5 → 1 → 1.5 → 2`)

**책임 밖 (ViewModel):**
- covering clip id, seekToken, playbackToken
- 모니터/트랙/드리프트 seek
- `notifyListeners` (콜백으로만 알림)

### 권장 API (단순하게 — 오버엔지니어 금지)

```dart
/// 가이드 §6: 타임라인 시각 T. 파일 timeupdate로 덮지 않는다.
class TimelinePlayheadClock {
  double get playheadSeconds;
  double get timelinePlaybackRate;
  String get timelinePlaybackRateLabel;
  bool get wantsPlayback;
  bool get isPlaying;

  void seekTo(double seconds, {required double spanSeconds, required bool resumeIfWasPlaying});
  void play({required double spanSeconds}); // span 끝이면 0부터
  void pause();
  void cycleTimelinePlaybackRate();
  void clampToSpan(double spanSeconds);

  /// wantsPlayback이면 틱 시작. onTick마다 ViewModel이 covering seek·notify.
  void syncTimer({
    required double Function() spanSeconds,
    required void Function() onTick,
    required void Function() onEndedAtSpan,
  });

  void dispose();
}
```

이름은 위와 동등하면 된다. **콜백 지옥·제네릭·스트림은 쓰지 말 것.**  
Timer + 필드 + 짧은 메서드면 충분하다.

### ViewModel 연결

1. `_playheadTimer` / `_lastPlayheadTickAt` / `_timelinePlaybackRate` / `_playheadSeconds`의 **틱·배속·play/pause 핵심**을 clock으로 이전.  
2. ViewModel은 `TimelinePlayheadClock` 인스턴스 하나 보유. getter는 clock에 위임.  
3. `_tickPlayhead` 안의 covering 처리(`_syncCoveringSeek`)는 **onTick 콜백**에 남긴다.  
4. `didTapTogglePlayback` / `didSeekToSeconds` / `didTapCycleTimelinePlaybackRate` / dispose는 clock API 호출로 단순화.  
5. `_pauseTimelinePlayback` / `_stopPlaybackAtTimelineEnd`는 clock.pause + ViewModel notify로 정리. 중복 pause 경로 합치기.

### 1차에서 지울·합칠 것

- ViewModel에 남은 동일 역할 private 타이머 필드·중복 pause
- 불필요 주석 복붙 / 죽은 심볼
- `isVideoPlaying`과 `wantsPlayback` 이중 조작이 헷갈리면: **재생 의도는 clock.wantsPlayback**, UI 아이콘은 `isPlaying == wantsPlayback`(갭에서도 바늘이 가면 playing)으로 통일·문서화

### 1차 검증

- [ ] 클립 끝·갭에서도 `T`가 span까지 진행 (동작 회귀 없음)
- [ ] Pause / span 끝에서만 정지
- [ ] 타임라인 배속 순환 동일
- [ ] `timeline_playhead_clock.dart`에 covering·JobTimeline·모니터 import 없음
- [ ] `flutter analyze` 해당 경로 치명 오류 없음

---

## 2차 — seek·배속 계산 헬퍼 분리

### 만들/확장 파일

**A.** `timeline_clip_playback.dart` (신규, presentation 또는 domain 인접 — **순수 함수면 domain `clip_file_position` 옆에 두어도 됨**. Flutter 의존 없으면 domain 쪽이 낫다. 기존 `clip_file_position.dart`에 얇게 추가해도 된다. **파일 하나·함수 짧게.**)

순수 계산만:

```dart
int fileSeekMillisecondsAt({
  required ClipPlaybackInput? clip,
  required double playheadSeconds,
  required double fallbackLocalSeconds, // bar.start 기준 폴백
});

double playbackRateAt({
  required ClipPlaybackInput? clip,
  required double playheadSeconds,
  required double timelinePlaybackRate,
});

int? fileContentEndMilliseconds({
  required ClipPlaybackInput clip,
});

bool doesFileDriftBeyond({
  required double fileSeconds,
  required double expectedFileSeconds,
  double thresholdSeconds = 0.1,
});
```

**B.** `video_playback_rate.dart`  
- 타임라인 배율 목록·다음 배율·라벨 포맷을 여기 또는 clock 근처 상수로 모은다.  
- `supportedVideoPlaybackRate` deprecated 잔여가 있으면 **삭제**하거나 호출부 없이 제거.

### ViewModel

- `fileSeekMilliseconds` / `playbackRateFor` / `fileContentEndMilliseconds` / 드리프트 비교 → 헬퍼 한 줄 호출.
- `_playbackInput(clip)`은 ViewModel에 남겨도 됨(엔티티→Input 매핑).
- `didReceiveVideoClock` 본문을 “클립 해석(VM) + drift 헬퍼 + seekToken++” 수준으로 짧게.

### 2차에서 지울·합칠 것

- ViewModel 안 중복 rate/seek 산식
- 쓰이지 않는 `playheadSecondsFromFilePosition` 호출 경로가 앱에 없으면 **도메인 함수는 유지**(다른 용도)하되 VM에서 파일→T 역산으로 `T`를 밀던 잔재 주석·코드 확인 후 제거
- 과도한 null 중첩·삼항 지옥 → early return

### 2차 검증

- [ ] 첫 시각≠0·배속 클립: seek ms / playbackRate 수치가 분리 전과 동일(수동 또는 기존 디버그)
- [ ] 스텝 시킹(rate 0·범위 밖) 동작 유지
- [ ] 헬퍼에 ViewModel·Fluent·위젯 import 없음
- [ ] `flutter analyze` 해당 경로 치명 오류 없음

---

## 간소화 규칙 (1·2차 공통)

1. **새 추상화는 파일당 하나.** Clock 위에 Manager/Controller/Coordinator를 또 두지 말 것.  
2. **동작 변경 PR과 섞지 말 것.** 분리 중 버그를 고치면 프롬프트 문서에 한 줄로 남긴다.  
3. **복잡한 소스 금지:** 중첩 콜백, 미사용 파라미터, “나중에 쓸” 플래그, 동일 의미 필드 둘.  
4. ViewModel public API (`playheadSeconds`, `wantsPlayback`, `seekToken`, …)는 UI가 깨지지 않게 **시그니처 유지**하거나 위임 getter로 유지.  
5. 테스트가 있으면 clock 틱(가짜 span·rate) 단위 테스트 추가를 우선. 없으면 수동 검증 체크리스트로 충분.

---

## 작업 순서 (복사용)

```text
# 구현: playhead T 시계 1차·2차 파일 분리 + 간소화

## 목적
단일 playhead T 로직을 timeline_playhead_clock.dart로 분리(1차)하고,
seek/배속/드리프트 순수 계산을 헬퍼로 분리(2차)한다.
동작(가이드 §6: T=타임라인 틱, 클립 끝나도 T→span, 파일로 T 덮지 않음)은 유지.
복잡한 분기·중복 상태·죽은 코드를 제거한다.

상세: docs/2026-10-28/playhead_시계_파일분리_1·2차_프롬프트.md

## 필독
- 위 문서 전문 + 단일_playhead_T_… 프롬프트 §2 To-Be
- video_multimodal_view_model.dart (playhead 구간)
- video_playback_rate.dart, clip_file_position.dart
- multimodal_video_stage.dart
- README 목적. guidelines 스킬(워킹 트리 밖). 요청 없으면 커밋 금지.

## 1차
1. timeline_playhead_clock.dart 추가 (틱·배속·play/pause/seek clamp/span 끝만)
2. ViewModel이 clock 보유·위임. onTick에서 _syncCoveringSeek + notify만
3. 중복 타이머/pause 경로 삭제

## 2차
4. fileSeek / playbackRate / contentEnd / drift 순수 함수로 추출
5. ViewModel·didReceiveVideoClock 얇게. deprecated rate 헬퍼 정리

## 검증
- 1차·2차 체크리스트 통과
- flutter analyze 해당 경로 치명 오류 없음
- 보드: A→갭→B, 클립 끝 후 바늘, Pause, span 끝, 배속×2

## 완료 기준
- clock 파일에 covering/모니터 없음
- 헬퍼에 ViewModel 없음
- ViewModel playhead 관련 코드가 읽기 쉽게 줄었고 동작 회귀 없음
```

---

## 구현 메모 (2026-10-28)

- [x] 1차: `timeline_playhead_clock.dart` — 틱·배속·play/pause/seek/span 끝. ViewModel `onTick`에서 covering seek.
- [x] 2차: `domain/timeline_clip_playback.dart` — seek ms / rate / contentEnd / drift.
- [x] `video_playback_rate.dart` — 타임라인 배율·라벨·틱 간격. `supportedVideoPlaybackRate` 삭제.
- [x] `isPlaying == wantsPlayback` 통일. `flutter analyze` 통과.

## 한 줄 요약

**1차:** `T`를 미는 시계만 `timeline_playhead_clock.dart`.  
**2차:** seek·배속·드리프트는 순수 헬퍼.  
**둘 다:** 동작 유지 + 코드 짧게.
