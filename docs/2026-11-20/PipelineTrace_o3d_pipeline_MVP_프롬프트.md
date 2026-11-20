# PipelineTrace o3d pipeline.glb MVP

## 목표

`pipeline.glb` 하나에 7 Stage·20 Node를 배치하고, Flutter에서 **카메라와 전체 애니메이션**만 제어하는 MVP를 만든다. Trace 기반 개별 Node 재질·애니 제어는 다음 단계다. 개별 Node 실시간 독립 제어가 핵심이면 o3d 공식 API만으로 충분한지 검증 결과를 따른다.

## o3d 제어 범위 검증 (결론)

| 요구 | O3DController 공식 API | 판정 |
|------|------------------------|------|
| 단일 GLB 표시 | `O3D.asset` | 충분 |
| 카메라 orbit/target | `cameraOrbit` / `cameraTarget` / `cameraControls` | MVP에 충분 |
| 전체(씬) 애니 1개 | `animationName` + `play`/`pause` (클립 **1개**만 활성) | MVP에 충분 |
| 머티리얼 variant 1개 | `variantName` | 전역 1개만 → 노드 독립 불가 |
| 노드별 색·emissive 동시 | 공식 API 없음 → `customJsCode` + model-viewer `materials` | **조건부** (메시/머티리얼 이름 계약 + JS) |
| 노드별 클립 애니 동시 재생 | `animationName`은 전역 1클립 | **부족** (Three mixer 직접 JS 필요, 취약) |

**결정:** MVP는 공식 API(카메라·전체 애니)만 쓴다. 노드 독립 실시간 제어가 필수면 Phase 2에서 `customJsCode` 머티리얼 경로를 쓰되, 노드별 독립 **클립 애니 동시 재생**은 o3d만으로 기대하지 않는다(Three 경로 또는 JS mixer).

## 먼저 읽을 것

1. `README.md` 목적 절
2. `.cursor/skills/apply-guidelines/SKILL.md`
3. `docs/2026-11-20/PipelineTrace_o3d_단일GLB_방식A_프롬프트.md`
4. `lib/src/domain/entities/pipeline_trace_graph.dart`
5. `lib/src/presentation/features/collection_monitoring/widgets/pipeline_trace_graph_o3d_view.dart`
6. https://pub.dev/packages/o3d

## 현재 상태

- `pipeline_full.glb` + Trace→머티리얼 JS 동기화가 이미 있음(방식 A)
- 이번 MVP는 그 위에 **카메라·전체 애니 중심**으로 재정렬하고 에셋명을 `pipeline.glb`로 통일

## 바꿀 것

1. `scripts/generate_pipeline_full_glb.mjs` → 출력 `assets/glb/pipeline/pipeline.glb` (7×20 배치·연결·바닥·`idle` 클립 유지)
2. `pipeline_trace_graph_o3d_view.dart` — MVP: 단일 `O3D.asset(pipeline.glb)`, 카메라 프리셋, play/pause·autoRotate. Trace→노드 JS 동기화는 **호출하지 않음**(Phase 2)
3. Stage/노드 칩은 Flutter로 상태 표시만 (기존 매퍼)
4. `pipeline_o3d_full_bridge.dart`는 Phase 2용으로 **유지·삭제 금지**. MVP 뷰에서 import하지 않음

## 유지할 것

- 2D · Three · ViewModel · 매퍼 · 모드 순환
- kit GLB·bridge 파일 삭제하지 않음

## 이번 작업에서 만들지 않음

- Trace→노드 재질/애니 Phase 2 본구현
- Blender 수동 모델링
- 새 상태관리

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
- O3D 모드: `pipeline.glb` 로드, 카메라 프리셋·play/pause·autoRotate 동작
- 칩은 Flutter 상태 표시
- 2D·Three 회귀 유지
