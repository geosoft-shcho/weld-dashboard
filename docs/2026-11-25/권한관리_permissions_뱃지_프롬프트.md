# 권한 관리 permissions 리스트 뱃지 UI

## 목표
권한 관리의 새/수정 다이얼로그에서 permissions 체크 목록을 `key` 뱃지 + 설명으로 보여 한눈에 구분되게 한다.

## 먼저 읽을 것
- [roles_admin_screen.dart](lib/src/presentation/features/account_admin/roles_admin_screen.dart) `_RoleEditDialog` permissions `ListView` (약 267–297행)
- [collection_timeline_host.dart](lib/src/presentation/features/collection_monitoring/widgets/collection_timeline_host.dart) `_LevelBadge` 스타일 참고
- [app_theme.dart](lib/src/presentation/core/themes/app_theme.dart) `ACCENT_STEEL`

## 현재 상태
- Checkbox content가 `'${permission.key} — ${permission.description}'` 한 줄 텍스트

## 바꿀 것
1. Checkbox content를 `Row`: key 뱃지(`DecoratedBox` + padding) + 간격 + 설명 `Text`(softWrap)
2. 뱃지 색은 `AppTheme.ACCENT_STEEL` 계열(`_LevelBadge`와 같은 톤)
3. `ConstrainedBox(maxWidth: 420)` 유지. 같은 파일 private 위젯으로 둬도 됨
4. 저장·선택 로직·다이얼로그 폭은 그대로

## 복잡한 코드 제거 및 금지
- 공용 Badge 컴포넌트·디자인 시스템 도입 금지
- ViewModel·도메인·다른 화면 수정 금지
- 범위 밖 리팩터 금지

## 완료 확인
- `./scripts/agent_check.sh` 통과
- 각 permission 행: 체크박스 · key 뱃지 · 설명
