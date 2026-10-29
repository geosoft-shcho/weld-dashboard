# 오디오 파형 waveform_visualizer UI

## 목표
타임라인 audio 클립 차트에서 직접 그린 CustomPaint 막대 대신, 앱에 이미 있는 waveform_visualizer로 정적 진폭 파형을 보여 준다. 음성 데이터는 기존처럼 GetClip contentUrl → .wave 또는 PCM WAV Range로 읽고, 탭하면 플레이헤드만 옮긴다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `lib/src/presentation/features/video_multimodal/widgets/audio_clip_chart.dart`
4. `lib/src/presentation/features/work_detail/widgets/work_detail_just_audio_stage.dart` (WaveformWidget·WaveformController 시드 패턴)
5. `lib/src/domain/use_cases/load_audio_waveform_use_case.dart`
6. `docs/2026-10-29/오디오_GetClip_WAV_파형_프롬프트.md`
7. 계약·화면안: 없음

## 현재 상태
- `AudioClipChart`가 `_AudioAmplitudePainter`로 막대를 직접 그린다.
- 진폭 목록은 ViewModel `audioAmplitudes`(LoadAudioWaveformUseCase)에서 온다.
- 작업 상세는 `WaveformController.updateAmplitude`로 시드한 뒤 `WaveformWidget`(bars)을 쓴다. `main.dart`에서 `WaveformVisualizer.initialize()` 호출됨.

## 바꿀 것
1. `AudioClipChart`를 StatefulWidget(또는 동일 수명)으로 두고, amplitudes가 바뀌면 controller를 reset한 뒤 각 진폭을 `updateAmplitude`로 시드한다. 작업 상세 `_didSeedWaveform`과 같은 방식.
2. `WaveformWidget` + `WaveformStyle`(bars, 그라데이션 없음, 타임라인 팔레트 색)로 그린다. Material이 필요하면 작업 상세처럼 기존 Material scope 패턴을 재사용한다.
3. 탭/제스처로 durationMs 비율 → `onTimeTapMs` 호출은 유지한다. 플레이헤드 위치는 기존처럼 세로 커서 오버레이 또는 동일 UX로 보이게 한다(패키지가 정적 커서 API를 안 주면 GestureDetector + 얇은 라인 Positioned로 유지).
4. `_AudioAmplitudePainter`와 쓰이지 않게 된 그리기 코드는 제거한다.
5. pubspec에 새 패키지를 추가하지 않는다. 데이터 로드 UseCase·GetClip·WAV Range 로직은 변경하지 않는다(버그 수정이 아니면).

## 유지할 것
- LoadAudioWaveformUseCase (.wave 우선, WAV Range 폴백)
- ViewModel `_loadAudioChart` / GetClip assetContentUrl
- audio 펼침 토글·시계열과 동시 펼침 금지·탭 seek
- 작업 상세 `WorkDetailJustAudioStage` 동작

## 이번 작업에서 만들지 않음
- waveform_pro / audio_waveforms 등 새 의존성
- 타임라인 안 just_audio 재생
- 스펙트로그램·FFT
- 로드 알고리즘 재설계

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- audio 클립을 펼치면 waveform_visualizer 막대 파형이 보인다.
- 진폭은 기존 로드 경로 데이터를 쓴다.
- 탭 시 플레이헤드만 이동한다.
- CustomPaint 자체 막대 페인터는 제거된다.
- 새 pub 의존성이 없다.
