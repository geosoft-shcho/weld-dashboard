# 웹캠 녹화 업로드와 STT 안내

## 문서 이력

| 일자 | 수정자 | 수정 내용 |
|---|---|---|
| 2026-11-02 | geosoft-Server | 운영 화면의 실제 흐름으로 고침 — 영상 · 음성 두 파일, 재생 바 자리로 옮김, 파형 JSON, 자막은 클립 자리 기준, 이어 올리기, 재시도 |
| 2026-10-15 | geosoft-Server | STT 도구 13번 "STT 빠른 처리" 추가를 반영 — STT 도구가 여럿일 때 고르는 법 |
| 2026-10-14 | geosoft-Server | 서버가 길이 없는 webm을 받을 때 다시 감싸 길이를 채우게 됨 — 화면의 길이 채우기 처리 삭제, STT·포즈 webm 확인 결과 반영. 2026-10-14 18:34 운영 적용 |
| 2026-10-14 | geosoft-Server | 최초 작성 — 화면에서 웹캠으로 녹화해 올리고, 타임라인에 놓고, STT를 거는 흐름을 프론트 기준으로 정리 |

## 한눈에

2026-11-02 운영 화면(`tks.faivv.ai`, 비디오 멀티모달)과 서버 코드로 확인한 흐름이다.

```
① 녹화 — 영상 · 음성을 파일 두 개로. 시작 시각을 적어 둔다          (서버 요청 없음)
② POST /assets — 파일마다 (metadata{jobId, timeOrigin} → file)    → asset, runId
③ GetRun(runId, wait_for_terminal) — 파일마다 후처리 끝까지
④ GetTimeline → ListAssets — 자동 배치된 클립과 길이를 찾는다
⑤ UpdateClip — `녹화 영상` · `녹화 음성` 트랙의 재생 바 자리로 옮긴다  (없으면 CreateClip)
⑥ 음성은 asset.properties.waveform_url로 파형을 그린다
⑦ STT는 자동으로 돌지 않는다. 필요하면 음성 클립에 StartRun
```

- 서버: `https://tks.faivv.ai/api`, 내부 `http://192.168.100.3:33210`(RPC는 Connect, 업로드는 일반 HTTP). 파일 주소 `contentUrl` · `waveform_url` 앞에도 이 주소를 붙인다.
- 업로드 규칙 전체는 `공사·작업·패스 관리와 업로드 안내.md` §4, 클립 좌표 · 재생은 `타임라인 그리기와 재생 안내.md`를 본다.

## 1. 녹화

영상과 음성을 파일 두 개(`camera-<시각>-video.webm`, `camera-<시각>-audio.webm`)로 만들고 같은 시작 시각을 준다. 두 파일을 따로 올리고 타임라인에도 따로 놓는다. mp4도 받는다.

크롬 `MediaRecorder`의 webm은 전체 길이가 파일에 적히지 않는데, 서버가 받을 때 다시 감싸(다시 인코딩하지 않음) 길이를 채운다. 화면에서 `fix-webm-duration` 같은 처리는 하지 않는다. 다시 감싸기가 실패하면 원본을 그대로 등록하고 `warnings`에 알린다.

**시작 시각(`timeOrigin`)**: 첫 프레임의 절대 시각이다. 녹화 `start` 이벤트 때 적어 둔다. 몇 십 ms 차이는 문제없다.

파일 이름은 표시용이다. 서버는 내용으로 종류를 정한다(영상 스트림이 있으면 `video`, 소리만 있으면 `audio`).

## 2. 올리기

```js
async function upload(file, startedAt) {
  const form = new FormData();
  form.append("metadata", JSON.stringify({
    jobId,                              // 이 작업에 첨부. 자동 배치가 이 첨부를 기준으로 한다
    passId,                             // 선택. 패스 자료로 붙일 때
    equipmentId,                        // 선택
    timeOrigin: startedAt.toISOString()
  }));
  form.append("file", file);            // 반드시 metadata 다음에
  const res = await fetch(`${base}/assets`, { method: "POST", body: form });
  if (!res.ok) throw new Error(`${res.status} ${await res.text()}`);
  return res.json();                    // { asset, runId, warnings, duplicateOf }
}
```

- 응답이 오면 등록은 끝났다. 후처리는 그 뒤에 돈다. `warnings`가 있으면 사용자에게 보여 준다.
- 끊기면 처음부터 다시 올린다. 큰 파일 · 외부망은 이어 올리기 `/uploads`(tus)를 쓴다(업로드 안내 §4.3).

## 3. 후처리 기다리기

```js
let run;
do {
  ({ run } = await tool.getRun({ runId, waitForTerminal: true, waitTimeoutSeconds: 60 }));
} while (run.status === RunStatus.QUEUED || run.status === RunStatus.RUNNING);
```

후처리는 속성 → 길이 → (음성이면) 파형 JSON → 자동 배치 순서다. PDF가 아닌 후처리는 자기 대기열(`postprocess`)에서 돌아 PDF를 기다리지 않는다.

- **실패하면** 사유는 `run.errorMessage`다. 다시 걸 때는 `RetryPostprocess(asset_id)`를 쓴다. 다시 걸어도 사람이 지운 클립은 되살아나지 않는다(자동 배치는 첨부마다 한 번).
- **파형 실패는 후처리 실패가 아니다.** 후처리는 성공으로 끝나고 `waveform_url`이 비어 있다.

자동 배치 자리는 `timeline_start_ns = timeOrigin − job.started_at`, 트랙은 `장비 · 계열`(장비가 없으면 `- · video`, `- · audio`)이다. `jobId`가 있고, 작업에 시작 시각이 있고, 녹화 시각이 작업(패스) 구간 안일 때만 놓는다. 밖이면 `warnings`로 알린다.

## 4. 클립 옮기기

녹화 시각이 작업 시작보다 한참 뒤일 수 있어(며칠 뒤면 수십 시간 지점) 화면이 재생 바 자리로 옮긴다.

1. `GetTimeline`에서 `source.asset_id`가 올린 에셋인 클립을 찾는다.
2. 길이는 `ListAssets`의 `duration_ns`로 안다.
3. 트랙 `녹화 영상` · `녹화 음성`으로 `UpdateClip`한다. 시작 = 재생 바, 끝 = 시작 + 길이.
4. 클립이 없으면(구간 밖 등) `CreateClip`으로 놓는다. 소스 구간을 비우면 Asset 전체다.

## 5. 파형

음성은 `asset.properties.waveform_url`의 JSON으로 그린다. 후처리가 끝난 뒤 생기므로 에셋을 다시 조회한다. 내용과 그리는 법은 `프론트 proto 공유 안내.md` "2026-11-02에 바뀐 것"을 본다.

## 6. STT 걸기

자동으로 돌지 않는다. STT 도구는 `ListTools`에서 `payloadKind`가 `stt`인 것이고, 지금 켜진 것은 1번 "STT faster-whisper"와 13번 "STT 빠른 처리"다. 13번은 실제 인식이 아니라 화면 시험용 목업이니 실제 자막은 1번으로 만든다. 번호를 코드에 적어 두지 않는다.

```js
const { run } = await tool.startRun({
  toolId: stt.toolId,
  trigger: RunTrigger.MANUAL,
  target: { clipId: audioClip.clipId },   // 음성 클립. 클립을 옮긴 뒤에 건다
});
```

- 대상은 클립 또는 에셋이다. 작업만 주면 바로 오류다.
- **클립에 걸면** 그 소스 구간만 받아 적고 자막을 그 클립 자리에 놓는다. **에셋에 걸면** 파일 전체를 받아 적고 녹화 시각 자리에 놓는다. 재생 바 자리로 옮기는 화면에서는 클립에 건다.
- 소리 없는 영상에 faster-whisper를 걸면 바로 `invalid_target`이다. 웹캠은 음성 파일이 따로 있으니 음성 클립에 건다.
- `StartRun`은 바로 `QUEUED`로 돌아온다. 화면을 떠났다 오면 `ListRuns({ target: { clipId } })`로 찾는다. 진행률은 오지 않으니 `updated_at`을 본다.

## 7. 결과 받기

| 무엇 | 어디 |
|---|---|
| 결과 JSON 파생 에셋(kind `subtitle`) | `run.outputAssetIds` |
| 자막 클립(`CLIP_KIND_SUBTITLE`) 문장마다 하나 | 같은 작업의 **"STT" 트랙**(겹치면 `STT run<실행 번호>`). 글자는 `clip.description`, 신뢰도는 `clip.provenance.confidence` |

```js
const { clips } = await compose.getTimeline({ jobId });
const subs = clips.filter(c => c.provenance?.runId === run.runId);
```

- 말이 없는 구간은 클립을 만들지 않는다. 성공했는데 자막이 없을 수 있다(자막 배치 실패도 서버 로그에만 남는다).
- 도구가 만든 클립이라 검수 전이다(`provenance.reviewed = false`). 고친 뒤 `UpdateClip`(`update_mask: "provenance.reviewed"`)으로 표시한다.
