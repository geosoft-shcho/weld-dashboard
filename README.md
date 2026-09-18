# weld-dashboard

# 배포

## WEB

1. 프로젝트 루트에서 웹 빌드
   ```bash
   flutter build web
   ```
2. `build/web`을 원격 서버에 배포
   ```bash
   scp -r build/web/* geosoft@192.168.100.3:/apps/serviceops/weld-dashboard/web/
   ```

원격 경로: `/apps/serviceops/weld-dashboard/web/`
