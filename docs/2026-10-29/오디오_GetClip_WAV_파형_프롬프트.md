# 오디오 GetClip WAV 파형

## 목표
타임라인 audio 클립(예: clipId 1006)을 펼치면 GetClip으로 받은 자산 `contentUrl`의 음성 데이터를 읽어 정적 진폭 그래프를 보여 준다. `.wave` 피크가 있으면 그것을 쓰고, 없으면(1006처럼 404) PCM WAV 본문을 Range로 샘플링해 파형을 만든다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md` (가이드라인 저장소는 워킹 트리 밖에서 읽기만)
3. `docs/2026-10-29/오디오_클립_음성파형_차트_프롬프트.md`
4. `lib/src/domain/use_cases/load_audio_waveform_use_case.dart`
5. `lib/src/presentation/features/video_multimodal/video_multimodal_view_model.dart` (`_loadAudioChart`)
6. `lib/src/data/datasources/remote/media_tag_data_source.dart` (`readBytes`)
7. `lib/src/domain/audio_waveform_data.dart`
8. 계약·화면안: 없음. 확인 사실: `sample-video.wav` HTTP 200, 형제 `.wave` HTTP 404, Accept-Ranges 지원·fmt pcm_s16le stereo 44100

## 현재 상태
- 차트 로드는 타임라인 `clip.contentUrl`의 `.wave` 형제만 받는다. 1006 자산은 WAV만 있어 `.wave`가 404라 파형이 비거나 오류다.
- GetClip `asset.contentUrl`을 차트 로드에 쓰지 않는다.
- `readBytes`는 전체 GET만 한다. 99MB WAV 전체 다운로드는 피해야 한다.

## 바꿀 것
1. `_loadAudioChart`에서 GetClip을 호출하고, `detail.assetContentUrl`이 있으면 그 URL로 파형을 로드한다. 없으면 기존 `clip.contentUrl`을 쓴다.
2. `readBytes`에 선택적 바이트 Range(`startByte`/`endByte`)를 넣는다. 206/200을 허용한다. repository·GetJobTimelineUseCase에 그대로 위임한다.
3. `LoadAudioWaveformUseCase`: 먼저 `.wave`를 시도하고, 실패·빈 응답이면 `contentUrl` WAV를 Range로 읽어 PCM(s16le) 피크를 `sampleCount`개 만든다. fmt가 PCM 16비트가 아니면 구분 가능한 오류를 반환한다.
4. WAV 헤더·피크 샘플 로직은 domain의 작은 순수 함수/클래스로 두고, 단위 테스트를 추가한다.

## 유지할 것
- 기존 audio 차트 펼침 UI·탭 seek·시계열과 동시 펼침 금지
- `.wave`가 있을 때 audiowaveform 파싱 경로
- String `readContent` 동작
- 타임라인 just_audio 재생(이번에도 넣지 않음)

## 이번 작업에서 만들지 않음
- mp3/aac 등 비-PCM 디코딩
- 스펙트로그램·재생 UI
- 전체 WAV 파일 일괄 다운로드를 기본 경로로 쓰는 것

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- clip 1006(또는 동일하게 `.wave` 없는 PCM WAV audio 클립)을 펼치면 진폭 막대가 보인다.
- GetClip 자산 contentUrl을 사용한다.
- `.wave`가 있는 클립은 이전처럼 `.wave`로 그린다.
- 앱이 죽지 않고, 실패 시 오류 문구가 보인다.
