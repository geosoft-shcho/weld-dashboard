# 오디오 차트 filled 파형 스타일

## 목표
타임라인 음성 클립 차트를 막대(bars)가 아니라 filled 연속 파형으로 보여 준다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/video_multimodal/widgets/audio_clip_chart.dart`
4. `docs/2026-10-29/오디오_파형_waveform_visualizer_프롬프트.md`
5. 계약·화면안: 없음

## 현재 상태
- `AudioClipChart`의 `WaveformStyle.waveformStyle`가 `WaveformDrawStyle.bars`이다.

## 바꿀 것
1. `audio_clip_chart.dart`에서 `WaveformDrawStyle.bars`를 `WaveformDrawStyle.filled`로 바꾼다.
2. bars 전용에만 의미 있는 `barCount`/`barSpacing`은 filled에 맞춰 제거하거나 패키지 기본에 맡긴다. `strokeWidth`는 파형 선이 보이게 유지한다(대략 2).
3. 시드·탭 seek·커서 오버레이·로딩/오류 UI·데이터 로드는 그대로 둔다.

## 유지할 것
- LoadAudioWaveformUseCase, GetClip contentUrl, ViewModel 펼침
- WaveformMaterialScope, 팔레트 색(KALE_300 / SAND_0)
- 작업 상세 JustAudioStage 스타일(bars 유지)

## 이번 작업에서 만들지 않음
- line/circular로의 추가 전환 UI
- 새 패키지, 재생 UI, 로드 로직 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 타임라인 audio 펼침 차트가 filled 파형으로 보인다.
- 막대(bars)가 아니다.
- 탭 seek와 데이터 로드는 이전과 같다.
