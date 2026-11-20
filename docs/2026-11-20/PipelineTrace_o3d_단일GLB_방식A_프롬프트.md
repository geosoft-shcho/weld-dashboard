# PipelineTrace o3d 단일 GLB (방식 A)

## 목표

전체 파이프라인(7 Stage · 20 Node · 연결선 · 바닥 · 장식)을 **하나의 GLB**로 두고, Flutter에서는 `O3D.asset` **1개**로 표시한다. Trace 상태는 기존 ViewModel·매퍼를 쓰고, 노드별 Idle/Running/Done/Error는 `O3DController` + model-viewer `customJsCode`(머티리얼·노드 제어)로 반영한다. Stage·노드 상세 칩은 Flutter UI로 유지한다.

## 먼저 읽을 것

1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `docs/2026-11-20/PipelineTrace_o3d_GLB_재구현_프롬프트.md`
4. `docs/2026-11-20/PipelineTrace_3D_이벤트노드_재구현_설계안.md`
5. `lib/src/domain/entities/pipeline_trace_graph.dart` (`pipelineStages` 20노드)
6. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_status_mapper.dart`
7. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_o3d_view.dart`
8. https://pub.dev/packages/o3d (`O3DController`, `customJsCode`, `animationName`, `play`)

## 현재 상태

- O3D 모드: 단계 kit GLB × 최대 7 + Flutter 칩·흐름 페인터
- Three / 2D / 매퍼 / ViewModel 유지
- Blender 원본 없음 → 절차적 단일 GLB 스크립트로 동일 메시 이름 계약을 만든다(이후 Blender 교체 가능)

## 바꿀 것

1. `scripts/generate_pipeline_full_glb.mjs` — 단일 `assets/glb/pipeline/pipeline_full.glb` 생성
   - 메시 이름: `node__{nodeId_with_underscore}` (예: `collect.field` → `node__collect_field`)
   - 머티리얼 이름: `mat__{...}` (노드별 고유, JS에서 색·emissive 변경)
   - 골격 연결선·바닥·간단 장식
   - 선택: 전체 `idle` 클립(대기 루프). 노드 독립 상태는 JS 머티리얼이 담당
2. `pipeline_o3d_full_bridge.dart` — nodeId↔메시명, 상태→RGBA, `O3DController.customJsCode` 페이로드
3. `pipeline_trace_graph_o3d_view.dart` — **단일** `O3D.asset(pipeline_full.glb)` + 컨트롤러 상태 동기화 + Stage/노드 Flutter 칩
4. `pubspec.yaml` — `pipeline_full.glb` 포함(폴더 에셋이면 자동)
5. kit 7파일·`pipeline_o3d_kit.dart`·flow painter는 **삭제하지 않음**(이번 범위 밖). O3D 모드는 단일 GLB 뷰만 쓴다

## 유지할 것

- 2D · Three · 매퍼 · ViewModel · Trace 도메인
- Flame 소스 파일
- 모드 순환 `2D → Three → O3D → 2D`

## 이번 작업에서 만들지 않음

- 실제 Blender 수동 모델링(스크립트 GLB가 계약 대체)
- 노드마다 O3D WebView
- 새 Provider/상태관리 계층
- kit GLB 삭제·Three 제거

## 상태 매핑 (노드)

| UX 상태 | pipelineFlowStatus / visual | GLB·JS |
|---------|----------------------------|--------|
| Idle | pending / idle | 어두운 baseColor, emissive 낮음 |
| Running | running / active | accent + emissive 발광, 미세 요동(JS) |
| Done | done | 청록 baseColor |
| Error | error / failed | 적색 + 점멸(JS pulse) |
| (warning/skipped) | warning/skipped | 주황 / 낮은 opacity |

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
- `./scripts/agent_check.sh test/pipeline_trace_graph_test.dart` 통과
- O3D 모드에서 단일 GLB 로드, 노드 상태색(Idle/Running/Done/Error) 반영
- Stage·노드 칩 Flutter 표시
- 2D·Three 회귀 유지
