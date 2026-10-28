# 단일 playhead `T` — 클립 끝나도 바늘은 계속 (현황 + 구현 프롬프트)

기준 가이드: `docs/2026-10-19/타임라인 그리기와 재생 안내.md` §6·§6.1·§6.2·§8.4  
대상: `lib/src/presentation/features/video_multimodal/`  
관련: `docs/2026-10-28/멀티모달_타임라인_그리기재생_현황_및_작업프롬프트.md` (P0 배속·contentEnd는 선행)

---

## 1. 현재 playhead `T` 로직 (As-Is)

### 1.1 상태

| 필드 | 역할 |
| --- | --- |
| `_playheadSeconds` | 보드 바늘 = 타임라인 시각 `T` (초) |
| `_wantsPlayback` | 사용자가 재생을 켠 상태(의도) |
| `_isVideoPlaying` | UI/플레이어에 “지금 재생 중”으로 보이는지 |
| `_timelinePlaybackRate` | 타임라인 배속(세션, 저장 안 함) — P0에서 추가 |
| 모니터 `focusedMonitorTrackId` | 멀티 모니터일 때 **이 칸만** 파일 시계로 `T`를 밈 |

보드·스테이지·시계열은 모두 이 `_playheadSeconds` 하나를 읽는다.

### 1.2 `T`를 누가 미는가 (현행)

```
재생 중 + 포커스/활성 영상 있음
  → MultimodalVideoPlayer onClock
  → ViewModel.didReceiveVideoClock
  → _followFileClock
  → playheadSecondsFromFilePosition(fileSeconds) 로 _playheadSeconds 갱신

스텝 시킹(배속 0·범위 밖)
  → ViewModel 타이머가 wall × timelineRate 로 _playheadSeconds 증가
  → 그동안 didReceiveVideoClock 은 early return
```

즉 **일반 재생에서는 파일 `currentTime`이 `T`의 원천**이다.  
가이드 §6·§6.2는 “재생 중 `T`는 실제 시간 × 타임라인 배속”, “`timeupdate`로 `T`를 덮지 않는다”인데, 앱은 **포커스 영상 추종**으로 `T`를 맞추는 쪽이다(P0에서 단일·포커스만 규칙 문서화).

### 1.3 클립에 닿을 때 / 끝날 때 (현행 — 갭의 핵심)

**닿을 때(시크·재생 시작)**  
- covering 영상 있으면 `fileSeekMilliseconds` / `playbackRateFor`로 플레이어에 위치·배속 전달.  
- `didSeekToSeconds`: 이전에 재생 중이었어도 **covering 영상이 없으면** `_wantsPlayback = false`로 꺼 버림.

**클립 끝** (`_followFileClock`):

```dart
if (mapped >= end) {          // 파일 시계가 클립 timeline_end 를 넘김
  _stopVideoAt(end);
  return;
}
```

`_stopVideoAt`:

```dart
_playheadSeconds = end 근처로 고정;
_isVideoPlaying = false;
_wantsPlayback = false;       // ← 타임라인 재생 의도까지 끔
```

**결과:** 보드 바늘이 클립 영상에 닿아 재생되다가 **그 클립이 끝나면 영상도 멈추고 `T`도 멈춘다.**  
갭(빈 구간)·다음 클립으로 바늘이 넘어가지 않는다.

가이드 §6 “주기마다”:

> 3. 없으면 영상을 멈추고 빈 화면으로 둔다. **시계는 계속 간다.**

가이드 §8.4 예시:

> A는 40초에 끝났으므로 빈 화면이다. **시계는 계속 가고** 센서 그래프도 계속 간다.

### 1.4 한 줄 진단

| 원칙 | 가이드 | 현재 앱 |
| --- | --- | --- |
| 시계의 주인 | `T`(wall × 타임라인 배속) | 포커스 영상 파일 시계(또는 스텝 타이머) |
| 클립 없음/끝 | 영상 stop, **`T` 계속** | `_stopVideoAt` → **`T`·재생 의도 둘 다 정지** |
| `T` 정지 조건 | 타임라인 **전체 끝** (`span`) | 사실상 **현재 클립 끝**에도 정지 |
| 빈 구간 seek 후 재생 | 재생 유지 + 빈 화면 | covering 없으면 재생 의도 off |

---

## 2. 목표 동작 (To-Be)

**단일 playhead `T`가 기준이다. 영상은 `T`를 따라간다. 클립이 끝나도 보드 바늘은 멈추지 않는다.**

1. 사용자가 재생을 켜면(`_wantsPlayback == true`) **`T`는 타임라인 span 끝까지** wall time × 타임라인 배속으로 진행한다.  
2. 매 주기(또는 `T` 갱신 시): 고른 트랙(모니터 있으면 포커스/모니터 규칙 유지)에서 `T`를 덮는 영상 클립을 고른다.  
   - **있으면** → 해당 영상 play + §1 식으로 seek/추종.  
   - **없으면**(클립 사이 공백·클립 직후) → 영상 pause/빈 화면. **`_wantsPlayback`는 유지, `T`는 계속.**  
3. 같은 트랙에서 다음 클립에 `T`가 닿으면 다시 play(§6.1 전환과 동일 취지).  
4. `T`가 `spanSeconds`에 닿았을 때만 타임라인 재생을 멈춘다.  
5. 버퍼링(`waiting`) 시에는 가이드대로 시계 일시 정지(이번 스프린트에서 가능하면 포함, 어려우면 후속 명시).

멀티 모니터 확장은 유지: **포커스 칸만 미리보기 “주인”**, 비포커스는 `T`를 밀지 않음. 다만 **`T`의 진행 원천은 파일 ended가 아니라 타임라인 시계**여야 한다.

---

## 3. 구현 작업 프롬프트 (복사용)

```text
# 구현: 단일 playhead T — 클립 끝나도 보드 바늘 계속

## 목적
`docs/2026-10-19/타임라인 그리기와 재생 안내.md` §6을 정본으로,
재생 중 타임라인 시각 `T`(`_playheadSeconds`)가 **유일한 시계**가 되게 한다.

바늘이 클립 영상에 닿으면 그 영상을 재생하고,
클립이 끝나거나 `T`가 빈 구간에 있으면 **영상만 멈추고** `T`는 span 끝까지 계속 진행한다.
클립 끝에서 보드 바늘이 멈추는 현행(`_stopVideoAt` → `_wantsPlayback = false`)을 없앤다.

현황·갭 상세: `docs/2026-10-28/단일_playhead_T_클립끝_후_진행_프롬프트.md` §1–2.

## 필독
- 가이드 §6 전문(시계 / 무엇이 보이나 / 주기마다 1–4), §6.1, §6.2 첫 문단, §8.4 ④
- `video_multimodal_view_model.dart`:
  - `didReceiveVideoClock`, `_followFileClock`, `_stopVideoAt`
  - `didSeekToSeconds`, `_doesPlayheadHaveVideo`, `_syncStepPlaybackDriver`
  - `_coveringVideoOnTrack`, `playbackRateFor`, `fileSeekMilliseconds`
- `multimodal_video_player.dart`, `multimodal_video_stage.dart`, `multimodal_timeline_board.dart`
- `clip_file_position.dart`
- README 목적(같은 작업 시각). 구현 전 guidelines 스킬로 워킹 트리 밖 가이드라인 읽기.
- 요청 없으면 커밋하지 말 것. guidelines 레포는 워킹 트리에 두지 말 것.

## 비범위
- P1 소스 막대·자르기/길이분리·kind별 뷰어(별도 프롬프트).
- proto/서버 변경.
- 모니터 칸 수 UX 개편(최대 4·포커스 규칙은 유지).

## 작업 목록

### A. `T` 진행 원천을 타임라인 시계로
1. `_wantsPlayback == true`이면 **wall clock × `_timelinePlaybackRate`** 로 `_playheadSeconds`를 증가시키는 드라이버를 둔다
   (기존 스텝 시킹 타이머를 일반화하거나, 재생 전용 타임라인 틱으로 통합).
2. `T >= spanSeconds`일 때만 재생 종료(`_wantsPlayback = false`). 클립 `timeline_end`에서는 종료하지 않는다.
3. 가이드 §6.2: 파일 `timeupdate`로 `T`를 **덮어쓰지 않는다**.
   - `_followFileClock`이 `_playheadSeconds = mapped`로 바늘을 끌고 가는 경로를 제거하거나,
     “드리프트 보정(±임계)용 참고”로만 남기고 **진행의 주인은 타임라인 틱**으로 고정.
   - 주석으로 “누가 `T`를 미는가”를 코드에 명시(가이드 §6 절 번호).

### B. 클립 덮음 ↔ 영상 play/pause (바늘은 유지)
4. 매 `T` 갱신(또는 틱)마다 covering 영상 재평가:
   - covering 있음 → `wantsPlayback` 유지한 채 해당 URL play + seek(`clip_file_position`).
   - covering 없음 → 플레이어 pause(또는 빈 스테이지). **`_wantsPlayback` 유지.** `_playheadSeconds` 계속.
5. `_followFileClock`의 `mapped >= end` → `_stopVideoAt(end)` 분기를 제거·교체:
   - 클립 끝 = covering 없음과 동일. 영상만 멈추고 `T`는 틱이 계속 민다.
6. `_stopVideoAt` / 시크 후 covering 없을 때 `_wantsPlayback = false`로 끄는 경로를 재검토:
   - **사용자 Pause**, **span 끝**, **명시적 Stop** 외에는 `_wantsPlayback`를 끄지 않는다.
   - `didSeekToSeconds`: 재생 중이었으면 covering 없어도 `_wantsPlayback` 유지(빈 화면으로 진행 가능).

### C. 다음 클립·갭
7. 같은 트랙에서 갭 이후 다음 클립에 `T`가 들어가면 자동으로 다시 play(§6 주기 4 / §6.1 취지).
8. 모니터 모드: 포커스 트랙 covering만 스테이지 주인; 비포커스는 `T`를 밀지 않음(회귀 유지).
9. 스텝 시킹(rate 0·범위 밖): 이미 타이머로 `T`를 미는 경로와 A의 드라이버를 하나로 맞춘다.
   클립 끝에서도 타이머를 끄지 않는다(span 끝만).

### D. 문서
10. `docs/2026-10-28/멀티모달_타임라인_그리기재생_현황_및_작업프롬프트.md` §1.3 또는 §2에
    “클립 끝에서 `T` 정지” 갭이 해소되었는지 한 줄 메모. 남으면 P2로 명시.

## 검증
- [ ] 클립 A(예: 0–10초)만 있는 트랙에서 재생 → A 끝(10초) 지나도 보드 바늘이 span까지 계속 이동. 영상은 10초 이후 pause/빈 화면.
- [ ] 같은 트랙에 A(0–10)·갭·B(15–25) → 재생 한 번으로 A play → 갭(빈 화면, 바늘 이동) → B play.
- [ ] Pause 버튼 → `T`와 영상 모두 정지. Play 재개 → 현재 `T`부터 동일 규칙.
- [ ] `T`가 span 끝에 닿으면 재생 종료(바늘·의도 정지).
- [ ] 모니터 2칸+: 포커스만 미리보기 주인; 비포커스 clock이 `T`를 밀지 않음.
- [ ] 타임라인 배속 ×2일 때 갭·다음 클립 진입 시각이 배속에 맞게 앞당겨짐.
- [ ] 첫 시각≠0 영상: seek 위치 = 첫시각 + Asset축(§5.1). contentEnd는 asset 기준 유지.
- [ ] `flutter analyze` 해당 경로 치명 오류 없음.

## 완료 기준
- 재생 중 클립이 끝나도 보드 바늘이 멈추지 않는다.
- covering 없음 = 영상 stop + `T` 계속; span 끝 = `T` 정지.
- 가이드 §6 “시계는 계속 간다” / §8.4 ④와 코드 주석이 연결된다.
- 요청 없는 커밋·guidelines 워킹트리 반입 없음.
```

---

## 4. 구현 메모 (2026-10-28)

- [x] `T` 원천 = `_playheadTimer`(wall × 타임라인 배속). 파일 시계는 드리프트 시 seek만(§6.2).
- [x] 클립 끝·갭: covering 없으면 스테이지 빈 문구, `_wantsPlayback` 유지, `T`는 span까지.
- [x] `_stopVideoAt` / `_followFileClock` / stuck 보정 제거. span 끝에서만 `_stopPlaybackAtTimelineEnd`.
- [x] `didSeekToSeconds`: covering 없어도 재생 의도 유지.

## 5. 한 줄 요약

**`T`가 끌고, 클립은 닿을 때만 따라 재생되며, 끝나도 바늘은 span까지 간다.**
