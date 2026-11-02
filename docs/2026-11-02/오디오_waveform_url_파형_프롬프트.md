# 오디오 waveform_url 파형 로드

## 목표
`ASSET_KIND_AUDIO` / 타임라인 audio 클립·에셋 상세 음성 파형을 `asset.properties.waveform_url` JSON으로 그린다. 프론트 `wav_pcm_peaks` Range 추출을 없앤다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/domain/use_cases/load_audio_waveform_use_case.dart`
4. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`_loadAudioChart`)
5. `lib/src/data/repositories/clip_detail_mapping.dart`
6. `lib/src/presentation/features/asset_lookup/widgets/asset_just_audio_stage.dart`
7. 계약: 서버 가이드(음성 파형 변경) — `waveform_url` JSON `{interval_ms, max_amplitudes}`

## 현재 상태
- `LoadAudioWaveformUseCase`가 `contentUrl` WAV를 Range로 peak 추출한다 (`wav_pcm_peaks`).
- 타임라인: `_loadAudioChart`가 GetClip `assetContentUrl`을 UseCase에 넘긴다. `waveform_url`·소스 구간은 안 씀.
- `ClipDetail`에 `channelNames`는 있으나 `waveformUrl` 필드 없음. properties에서 `waveform_url` 미추출.
- 에셋 상세: `AssetJustAudioStage`가 `contentUrl`만 UseCase에 넘김. `AssetLookupRow.propertiesJson`은 있음.
- `AudioClipChart`는 이미 피크 정규화(`_normalizedAmplitudes`) 후 `waveform_pro`로 그린다(대칭 continuous).
- URL은 `MediaTagDataSource.resolveContentUrl`로 `MEDIA_TAG_BASE_URL + path` 붙임. `/api` 누락 시 HTML 200 주의 — resolve 경로 유지.

## 바꿀 것
1. **GetClip 매핑**: `asset.properties.waveform_url` 문자열을 읽어 `resolveContentUrl`한 값을 `ClipDetail.waveformUrl`로 둔다 (`channelNamesFromProperties`와 같은 방식).
2. **`LoadAudioWaveformUseCase`**: 시그니처를 `waveformUrl` + 선택적 `sourceStartNs`/`sourceEndNs`로 바꾼다.
   - `waveformUrl` 비면 amplitudes 빈 목록·에러 없이 반환(가이드: 파형 없이 표시). **빈 파형 + errorMessage 비움**으로 통일해 차트가 “파형 데이터 없음”만 보이게.
   - URL 전체 GET(`readContent` 또는 `readBytes`) → JSON 파싱 `interval_ms`, `max_amplitudes`.
   - 소스 구간: start/end ns가 있으면
     - `start = floor(start_ns / 1e6 / interval_ms)`
     - `end = ceil(end_ns / 1e6 / interval_ms)`
     - 슬라이스; 비어 있으면 전체.
   - `interval_ms`는 코드 상수로 두지 않고 JSON에서 읽음.
   - PCM/`wav_pcm_peaks` 호출 전부 제거.
3. **ViewModel `_loadAudioChart`**: GetClip에서 `waveformUrl`·`sourceStartNs`/`sourceEndNs`를 UseCase에 전달. `assetContentUrl`로 WAV peak 하지 않음.
4. **에셋 상세**: `propertiesJson`에서 `waveform_url` 파싱 → resolve 후 UseCase 호출(소스 구간 없음=전체). `AssetJustAudioStage`에 waveformUrl 전달 또는 위젯에서 properties 파싱.
5. **테스트**: `load_audio_waveform_use_case_test`를 JSON+슬라이스 케이스로 교체. `wav_pcm_peaks`가 UseCase 전용이었으면 파일·단독 테스트는 가이드라인상 죽은 코드면 제거(다른 참조 없으면 `wav_pcm_peaks.dart`·`wav_pcm_peaks_test.dart` 삭제).
6. **정규화**: 가이드 권장 — 타임라인 `AudioClipChart` 기존 정규화 유지. 에셋 상세도 동일하게 피크 정규화. UseCase는 raw 0~1을 반환하고, 그리기 쪽에서 정규화하는 현재 타임라인 방식을 에셋에도 맞춤.

## 유지할 것
- `waveform_pro` 그리기 UI (`AudioClipChart`, `AssetJustAudioStage`)
- 재생 URL은 기존 `contentUrl`/webm (파형과 분리)
- Properties 필드 표시 구조

## 이번 작업에서 만들지 않음
- 서버 peak 생성
- webm 디코딩
- 새 파형 패키지
- Timeline.embedded_at

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- audio 클립 펼침 시 `…/xxx.waveform.json`만 요청하고 `.wav` Range peak 요청이 없다.
- JSON `interval_ms`·소스 구간 슬라이스가 적용된다.
- `waveform_url` 없으면 파형 없이 표시(에러 폭주 없음).
- 에셋 상세 음성도 동일 JSON 경로.
- `flutter test test/load_audio_waveform_use_case_test.dart` 통과.
