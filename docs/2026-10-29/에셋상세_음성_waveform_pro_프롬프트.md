# 에셋 상세 음성 waveform_pro

## 목표
에셋 상세의 음성 확장자 미리보기 파형을 타임라인과 같은 waveform_pro(WaveformTimeline continuous)로 보여 주고, 원격 contentUrl에서도 GetClip 방식 진폭을 그린다. 재생·시크는 유지한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/presentation/features/asset_lookup/widgets/asset_preview_pane.dart`
4. `lib/src/presentation/features/work_detail/widgets/work_detail_just_audio_stage.dart`
5. `lib/src/presentation/features/video_multimodal/widgets/audio_clip_chart.dart`
6. `lib/src/domain/use_cases/load_audio_waveform_use_case.dart`
7. 계약·화면안: 없음

## 현재 상태
- AssetPreviewPane 음성 분기가 WorkDetailJustAudioStage(waveform_visualizer)를 쓴다.
- HTTP contentUrl이면 파형 시드를 하지 않는다.
- 작업 상세도 같은 JustAudioStage를 쓴다.

## 바꿀 것
1. asset_lookup 쪽에 just_audio 재생 + waveform_pro WaveformTimeline(continuous) 위젯을 둔다(기존 JustAudioStage를 에셋 전용으로 복제·교체하지 말고, 에셋 미리보기 책임의 한 위젯으로 둔다).
2. 진폭은 locator의 LoadAudioWaveformUseCase.execute(contentUrl)로 읽는다.
3. WaveformData(samples, durationSeconds) + playheadPosition(재생 위치 초), onTap → seek. showTimeRuler/zoom/region/markers는 끈다. 스타일은 continuous, AppTheme 색.
4. AssetPreviewPane 음성 분기만 이 위젯으로 바꾼다.
5. 재생/일시정지·Slider·duration 표시는 기존 JustAudioStage와 같은 수준으로 유지한다.

## 유지할 것
- WorkDetailJustAudioStage + waveform_visualizer(작업 상세)
- pubspec waveform_visualizer
- 에셋 상세 레이아웃·높이(_heightOf audio)
- 타임라인 AudioClipChart

## 이번 작업에서 만들지 않음
- 작업 상세를 waveform_pro로 이전
- 업로드 다이얼로그 파형 변경
- 로드 알고리즘·패키지 버전 변경

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- 에셋 상세 음성 미리보기에 WaveformTimeline continuous가 보인다.
- HTTP contentUrl에서도 진폭이 보인다(로드 성공 시).
- 재생·탭/슬라이더 seek가 된다.
- 작업 상세 음성은 waveform_visualizer 그대로다.
