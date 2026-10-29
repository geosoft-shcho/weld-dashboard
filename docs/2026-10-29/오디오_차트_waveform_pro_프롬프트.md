# 오디오 차트 waveform_pro

## 목표
타임라인 audio 클립 차트를 waveform_pro의 WaveformTimeline(continuous)으로 그려, GetClip으로 읽은 진폭 데이터를 전문 파형 그래프로 보여 준다. 탭하면 플레이헤드만 옮긴다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/audio_clip_chart.dart`
4. `lib/src/domain/use_cases/load_audio_waveform_use_case.dart`
5. `pubspec.yaml`
6. `docs/2026-10-29/오디오_파형_waveform_visualizer_프롬프트.md`
7. 계약·화면안: 없음

## 현재 상태
- `AudioClipChart`가 `waveform_visualizer`의 WaveformWidget(line)으로 그린다.
- 진폭은 ViewModel `audioAmplitudes`, 길이는 `durationMs`이다.
- 작업 상세는 계속 `waveform_visualizer`를 쓴다.

## 바꿀 것
1. `pubspec.yaml`에 `waveform_pro: ^1.1.5`를 추가하고 `flutter pub get`한다.
2. `AudioClipChart`에서 waveform_visualizer Controller/Widget 시드를 제거한다.
3. amplitudes와 durationMs로 `WaveformData(samples: amplitudes, durationSeconds: durationMs/1000)`를 만들고 `WaveformTimeline`에 넣는다.
4. 스타일은 continuous 파형, 타임라인 팔레트 색(KALE_300 등). 시간 눈금·리전·줌 UI는 끄거나 최소로 둔다(`showTimeRuler: false` 등 API가 허용하는 범위).
5. `onTap(seconds)` → ms로 바꿔 기존 `onTimeTapMs`에 연결한다. `playheadPosition`은 selectedTimeMs/1000초로 넘긴다.
6. Material이 필요하면 기존 WaveformMaterialScope를 유지한다. waveform_visualizer import는 이 파일에서 제거한다.
7. pubspec에서 waveform_visualizer는 작업 상세가 쓰므로 제거하지 않는다.

## 유지할 것
- LoadAudioWaveformUseCase, GetClip assetContentUrl, ViewModel 펼침/탭 seek
- 작업 상세 WorkDetailJustAudioStage + waveform_visualizer
- 로딩·오류·빈 데이터 문구

## 이번 작업에서 만들지 않음
- 타임라인 안 just_audio 재생
- waveform_pro 줌/리전/마커 고급 UI 노출
- 로드 알고리즘 변경, 스펙트로그램
- 작업 상세를 waveform_pro로 이전

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- pubspec에 waveform_pro가 있다.
- 타임라인 audio 펼침 시 WaveformTimeline continuous 파형이 보인다.
- 탭 시 플레이헤드만 이동한다.
- AudioClipChart에 waveform_visualizer가 없다.
- 데이터 로드 경로는 이전과 같다.
