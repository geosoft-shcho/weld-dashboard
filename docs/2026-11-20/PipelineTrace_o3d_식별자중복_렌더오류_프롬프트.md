# PipelineTrace O3D 식별자 중복 렌더링 오류 수정

## 증상

```
SyntaxError: Failed to execute 'append' on 'Element':
Identifier 'o3dpipelineFull' has already been declared
```
2D↔O3D 전환·핫리로드로 O3D 뷰가 재마운트될 때 렌더가 깨진다.

## 원인

o3d(`utils.dart`)가 마운트마다 `relatedJs`로 인라인 `<script>`에 `const o3d<id> = ...`를 전역 선언한다. 우리가 `O3D.asset(id: 'pipelineFull')`로 id를 고정해, 재마운트 시 동일 `const o3dpipelineFull`이 전역 렉시컬 스코프에서 재선언 → SyntaxError.

## 수정

1. `pipeline_trace_graph_o3d_view.dart` — `O3D.asset`의 `id: 'pipelineFull'` 제거. o3d가 마운트마다 유니크 id를 생성해 `const` 충돌을 없앤다. 컨트롤러는 내부적으로 그 id를 받으므로 카메라·재생 호출은 그대로 동작.
2. `pipeline_o3d_full_bridge.dart` — 고정 변수명 `o3dpipelineFull` 의존 제거. 적용 JS가 `document.querySelectorAll('model-viewer')`로 현재 연결된 요소를 찾는다. 클릭 리플 리스너는 요소별(`__pipelineRippleBound`)로 바인딩해 재마운트에도 유지. 미사용 `pipelineO3dViewerJsName` 상수 제거.

## 금지

- 새 추상 계층·래퍼 금지. o3d pub 캐시 수정 금지.
- 범위 밖 리팩터 금지.

## 확인

- `./scripts/agent_check.sh` 통과
- 핫리스타트(R) 후 2D↔O3D 전환을 반복해도 SyntaxError 없음, 상태 애니·클릭 스윕 정상
