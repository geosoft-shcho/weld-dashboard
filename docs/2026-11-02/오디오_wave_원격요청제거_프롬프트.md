# 오디오 .wave 원격 요청 제거

## 목표
타임라인 audio 클립·에셋 상세 음성 파형 로드 시 `…/23364.wave` 같은 형제 `.wave` URL을 프론트가 더 이상 요청하지 않는다. `contentUrl`의 `.wav`(등 원본 URL)만 PCM Range로 읽어 진폭을 만든다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/domain/use_cases/load_audio_waveform_use_case.dart`
4. `test/load_audio_waveform_use_case_test.dart`
5. 계약·화면안: 없음

## 현재 상태
- `load_audio_waveform_use_case.dart`: `execute`가 `AudioWaveformData.assetPathFor(contentUrl)`로 `.wave` URL을 만든 뒤 `_loadWavePeaks` → `readBytes(waveUrl)`를 **먼저** 호출한다. 실패·빈 응답이면 `_loadWavPeaks(contentUrl)`로 PCM WAV Range 폴백한다. 이 1차 호출이 `23364.wave` 404의 원인이다.
- 타임라인·에셋 상세는 모두 이 UseCase를 쓴다 (`_loadAudioChart`, `AssetJustAudioStage._loadWaveform`).
- `work_detail_waveform_loader.dart`: **원격 HTTP가 아니라** `rootBundle` 로컬 에셋 `.wave`를 읽는다. 이번 404와 무관하다.

## 바꿀 것
1. `LoadAudioWaveformUseCase.execute`: `.wave` 형제 URL 생성·`_loadWavePeaks` 호출을 제거한다. `contentUrl`이 비어 있지 않으면 바로 `_loadWavPeaks(contentUrl)`만 실행한다.
2. `_loadWavePeaks` 메서드와 UseCase 안의 `AudioWaveformData` import를 제거한다 (이 UseCase에서만 쓰이던 경우).
3. `test/load_audio_waveform_use_case_test.dart`:
   - `.wave` URL 변환·`.wave` 바이트 로드·“`.wave` 없을 때 폴백” 기대를 제거하거나, **contentUrl(`.wav`)만** Range로 읽는 케이스로 바꾼다.
   - `readUrls`에 `.wave`가 없어야 한다.

## 유지할 것
- `_loadWavPeaks` / `wav_pcm_peaks` Range 샘플링·`sampleCount`·에러 메시지 동작
- 타임라인 `AudioClipChart`·에셋 `AssetJustAudioStage` 호출 흐름
- `AudioWaveformData` 클래스와 work_detail 로컬 bundle 파형 로더 (원격 `.wave` 요청이 아님)
- ViewModel·UI 위젯 구조

## 이번 작업에서 만들지 않음
- work_detail 로컬 `.wave` 에셋 경로 변경
- 새 파형 패키지 도입
- mp3 등 비-PCM 포맷 디코딩 추가
- 서버에 `.wave` 생성·배포

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 파형 로드 시 네트워크에 `*.wave` 요청이 나가지 않는다.
- `…/23364.wav` contentUrl로 PCM peak 파형이 기존처럼 그려진다.
- `flutter test test/load_audio_waveform_use_case_test.dart` 통과
