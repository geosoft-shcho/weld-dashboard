# GetPassWaveform 변경 안내 (work.proto)

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
| 2026-10-01 | geosoft-Server | 처음 작성 — 비교를 패스끼리만 하도록 변경, DTW 옵션 추가, 칸 번호 변경 |

## 한눈에

`mediatag/proto/mediatag/work/v1/work.proto`의 `WorkService.GetPassWaveform` 요청이 바뀌었습니다(mediatag 94eadf1).
응답 메시지 모양은 그대로입니다. **칸 번호가 바뀌어 proto를 다시 받아 코드를 새로 생성해야 합니다.**

| 무엇 | 전(9b38255, 프론트에 전달한 zip) | 후 |
|---|---|---|
| 비교 대상 지정 | `comparison_job_id` — 서버가 같은 `pass_no` 패스를 찾음 | `comparison_pass_id` — 화면이 패스를 고름 |
| DTW | 없음 | `normalize = WAVEFORM_NORMALIZE_DTW` |
| 칸 번호 | `channels = 3`, `max_points = 4` | `channels = 2`, `max_points = 3` |

## 요청 메시지

```proto
message GetPassWaveformRequest {
  string pass_id = 1;
  repeated string channels = 2; // 비우면 전체 채널(DTW면 용접 4채널). "imu" = 앞·뒤 IMU 전부
  int32 max_points = 3;         // 시리즈당 점 상한(화면용 줄이기). 0이면 서버 기본값
  string comparison_pass_id = 4; // 비교할 패스
  WaveformNormalize normalize = 5;
}

enum WaveformNormalize {
  WAVEFORM_NORMALIZE_UNSPECIFIED = 0; // = 원본. 파일마다 시리즈 하나, 시각은 패스 시작 기준
  WAVEFORM_NORMALIZE_DTW = 1;         // 비교 파형을 대상 파형의 시간축에 DTW로 맞춤
}
```

## 바뀐 점

### 1. 비교는 패스끼리만 — `comparison_job_id` 삭제, `comparison_pass_id` 추가

- 전에는 비교할 **작업**을 주면 서버가 같은 `pass_no`의 패스를 찾았습니다. 이제 비교할 **패스**를 화면이 직접 줍니다.
- `comparison_job_id`는 지웠습니다. 예전 코드가 JSON으로 `comparisonJobId`를 보내면 오류 없이 무시되어
  비교 파형이 오지 않습니다.
- `comparison_pass_id`가 비면 `comparison`은 오지 않고, 없는 패스 ID면 `not_found`입니다.

화면 흐름:

1. 비교할 작업을 고른다(지금은 명장 작업 — `ListJobs`의 `master_only`).
2. `ListPasses(job_id)`로 그 작업의 패스 목록을 받는다.
3. 짝 패스를 골라 `comparison_pass_id`에 넣어 요청한다.

짝 고르는 규칙(권장, 서버는 강제하지 않음) — 패스 수가 작업마다 다르기 때문입니다:

| 보고 있는 패스 | 비교 작업에서 고를 패스 |
|---|---|
| 처음 패스 | 처음 패스 |
| 끝 패스 | 끝 패스(번호가 달라도) |
| 가운데 패스 | 같은 `pass_no`(비교 쪽에서도 가운데일 때), 없으면 사용자가 고르게 |

기본 짝을 이렇게 잡아 주고, 사용자가 목록에서 다른 패스로 바꿀 수 있게 하면 됩니다.

### 2. `normalize` 추가 — DTW로 맞춰 보기

- `WAVEFORM_NORMALIZE_DTW`를 주면 서버가 두 패스의 파형을 DTW 서버에 보내 맞춘 파형을 받아 돌려줍니다(저장 안 함).
  `comparison_pass_id`가 있을 때만 쓰이고, 없으면 원본 그대로 옵니다.
- 기준은 `pass_id`의 패스입니다. 기준을 바꾸려면 두 패스를 바꿔서 요청합니다.
- DTW일 때 응답 모양:
  - `target`·`comparison` 모두 **시리즈 하나**로 옵니다(여러 파일을 한 격자로 모은 것이라 `asset_id`·`equipment_id` 없음).
  - 대상은 그대로이고 비교가 대상의 시간축에 맞춰져, 두 시리즈는 시각(`t_offset_ns`)·길이가 같습니다.
  - 용접 채널은 이름이 통일됩니다: `current_a`·`voltage_v`·`wire_feed_speed_mpm`·`rotation_speed_rpm`
    (원본에서는 파일마다 `전류_A`, `current_A` 등으로 다름).
  - 기본은 이 네 채널(전류·전압·송급 속도·RPM)만 옵니다. 그 밖의 채널(IMU 자이로 등)은 `channels`에 적은 것만
    추가되고, 이름은 `DEMO-DEPTH-FRONT/gyro_x`(장비 ID/채널) 또는 원본 이름 그대로입니다. `channels`에는 원본 채널
    이름(`gyro_x`)을 적습니다.
  - `channels`에 `"imu"`를 적으면 앞·뒤 IMU의 `acc_x`~`gyro_z` 여섯 채널씩(모두 12개)을 한 번에 고릅니다(원본 보기에서도 같음).
  - 채널마다 따로 맞춥니다. 두 패스에 다 있는 채널만 옵니다.
  - 정렬은 원본 간격(30fps)의 전체 길이로 하고, `max_points`(기본 2000)로 줄이는 것은 맞춘 뒤입니다.
- **지금은 동작하지 않습니다.** DTW 서버가 아직 없어 `invalid_argument`("DTW 서버(DTW_GRPC_ADDR)가 설정되지 않음")가
  옵니다(`docs/설계/DTW 서버 연동 요청.md`). 화면은 오류가 오면 원본 보기로 돌아가게 해 주세요.

### 3. 칸 번호 변경

`comparison_job_id`(2번)를 지우면서 뒤 칸을 당겼습니다. Connect JSON은 이름으로 주고받아 영향이 없지만,
바이너리(protobuf) 인코딩을 쓰면 예전 생성 코드로는 `channels`·`max_points`가 엇갈립니다. 새 proto로 다시 생성해 주세요.

## 요청 예

```json
// 원본 겹쳐 보기
{"passId": "JOB-DEMO_00-P1050-1-20260916_C7C3-P01",
 "comparisonPassId": "JOB-DEMO_00-P1050-2-20260916_CA13-P01",
 "maxPoints": 500}

// DTW로 맞춰 보기 + 양쪽 IMU
{"passId": "JOB-DEMO_00-P1050-1-20260916_C7C3-P01",
 "comparisonPassId": "JOB-DEMO_00-P1050-2-20260916_CA13-P01",
 "normalize": "WAVEFORM_NORMALIZE_DTW",
 "channels": ["imu"]}
```
