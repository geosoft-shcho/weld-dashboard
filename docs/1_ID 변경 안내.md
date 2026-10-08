[mediatag] proto 변경 ① ID가 숫자로 바뀌었습니다

서버에는 10월 8일에 반영됐고, 예전 proto로 만든 화면은 지금 서버와 맞지 않습니다. (기준: mediatag main 3841319)

모든 시스템 ID(job, pass, asset, clip, track, 라벨 값, 성적서 세트, tool, run, worker, equipment)가 string에서 int64로 바뀌었습니다. 필드 이름과 번호는 그대로입니다. JSON에서는 "128" 같은 글자로 오고, 값이 없으면 0입니다. 예전 ID(ast_…, JOB-…)는 더 쓸 수 없고, 작업의 예전 ID 모양은 Job.job_key로 옵니다.

타입 말고 바뀐 곳은 세 군데입니다. 도구 실행 대상이 target_id에서 target(job_id, asset_id, clip_id 중 하나)으로 바뀌었고, Job.item_abbr가 삭제됐고, Provenance.input_asset_ids가 parent_asset_id(하나)로 바뀌었습니다.

자세한 내용은 첨부의 "ID 숫자 전환 안내.md"에 있습니다.
