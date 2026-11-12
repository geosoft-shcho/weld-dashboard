# GetPassWaveform tOffsetNs → timeMs 변환

## 목표
품질/패스 파형에서 `tOffsetNs`를 CSV와 같이 ms로 나눠 `WaveformRow.timeMs`에 넣어 X축·시분초 표기가 경과 시간에 맞게 한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `lib/src/data/repositories/remote_pass_waveform_repository.dart`
4. `lib/src/domain/timeseries_csv_parser.dart` (`_timeMs` ns → `/ 1e6`)
5. 없음

## 현재 상태
- `_rowsFromWaveform`: `timeMs: series.tOffsetNs[index].toInt()` — ns를 그대로 넣어 시분초가 비정상.

## 바꿀 것
1. `timeMs: (series.tOffsetNs[index].toDouble() / 1e6).round()` (CSV `t_offset_ns`와 동일).

## 유지할 것
- 채널 매핑·시리즈 역할·차트 UI
- CSV 파서 로직

## 이번 작업에서 만들지 않음
- 차트 표기 포맷 추가 변경, proto 재생성

## 복잡한 코드 제거 및 금지
- 한 화면·한 동작을 위해 새 추상 계층, 전략, 팩토리, 제네릭 헬퍼를 만들지 않는다.
- 같은 역할의 위젯, ViewModel, UseCase, 화면 흐름이 있으면 그것을 쓴다.
- 이번 변경으로 쓰이지 않게 된 분기, 플래그, 래퍼, 죽은 코드는 제거한다.
- 조건 중첩과 모드 플래그 조합으로 경우를 늘리지 않는다.
- 호출을 한 겹 감싸기 위한 파일은 만들지 않는다. 파일 분리는 책임이 분명할 때만 한다.
- 새 상태관리, 새 디자인 시스템, 카드 UI를 도입하지 않는다.
- 프롬프트 범위 밖의 리팩터, 이름 정리, 스타일 통일을 끼워 넣지 않는다.

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 품질/패스 X축이 대략 `tOffsetNs/1e9` 초의 시분초로 보임
