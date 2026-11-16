# GetPassWaveform 비교 요약 UI 연동

## 목표
DTW 비교 시 서버 `compare_summary`를 패스 프로필 비교 지표 표에 채널별로 보여 준다.
mean_diff NaN·similarity 미설정은 "-"로 표시한다.

## 먼저 읽을 것
1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `docs/2026-11-16/README.md` 「2026-11-16에 바뀐 것」
4. `protos/mediatag/work/v1/work.proto` (`GetPassWaveformResponse`, `WaveformChannelCompare`)
5. `docs/2026-11-12/패스_비교지표_레이아웃_프롬프트.md`
6. `lib/src/presentation/features/pass_profile/widgets/pass_compare_summary.dart`
7. `lib/src/data/repositories/remote_pass_waveform_repository.dart`
8. `lib/src/domain/entities/pass_waveform_series.dart`
9. `lib/src/presentation/features/pass_profile/pass_profile_screen.dart`

## 현재 상태
- `PassCompareSummary`: 서버 미구현 플레이스홀더 표. props 없음.
- generated `work.pb.dart`: `compare_summary` 미생성.
- remote repo → `PassWaveformSeries`: 요약 미매핑.
- 화면은 `PassCompareSummary()`를 인자 없이 배치.

## 바꿀 것
1. `flutter pub get` 후 `buf generate`로 `WaveformChannelCompare`·`compareSummary` 반영.
2. 도메인 엔티티(예: `WaveformChannelCompareSummary`)와 `PassWaveformSeries.compareSummary` 추가.
3. `RemotePassWaveformRepository`에서 응답 `compare_summary`를 매핑. mean_diff NaN은 null.
4. catalog/board/view model에 요약 목록을 전달(기존 `ChannelCompareStats` 계산·필드는 유지, UI는 서버 요약만 사용).
5. `PassCompareSummary`를 서버 목록으로 갱신:
   - 비어 있으면 기존처럼 값 `-`(비교 없음·원본·미응답).
   - 있으면 표: 채널 | 평균 차이 | 유사도 (예: `current_a` · `+12.3 A` · `0.82`).
   - mean_diff NaN/`null` → `-`, similarity 없음 → `-`.
   - `서버 미구현` 부제 제거.
6. `pass_profile_screen`에서 board/view model의 요약을 위젯에 넘김.

## 유지할 것
- 차트·툴바·비교 작업 콤보·레이아웃(flex 8/2).
- `ChannelCompareStats` / `compareStats` 도메인·테스트(이번 UI에 다시 꽂지 않음).
- quality_issue 화면.
- generated 수동 편집 금지.

## 이번 작업에서 만들지 않음
- 클라이언트 mean_diff/similarity 재계산.
- 아크 구간 필터.
- 설명 열 유지 또는 새 카드/디자인 시스템.
- ChannelCompareStats 제거 리팩터.

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
- DTW+비교 패스일 때 채널별 평균 차이·유사도 표시
- NaN mean_diff·빈 similarity는 `-`
- 비교 없음/원본이면 표 값 `-` 또는 빈 요약
- `서버 미구현` 문구 없음
