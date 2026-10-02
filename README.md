# weld-dashboard

여러 공정의 멀티모달 수집 데이터를 같은 작업 시각 기준으로 사용자가 볼 수 있게 가시화하는 대시보드입니다. 시계열, 영상, 음성, 품질처럼 형태가 다른 수집값을 한 흐름으로 대조하고, 공정이 바뀌어도 같은 방식으로 확장하는 것이 목적입니다. 이 앱이 맡는 일은 수집값의 가시화입니다.

## MediaTag 연결

앱 조회는 mediatag v1 `WorkService`와 `AssetService`를 Connect 프로토콜로 호출합니다.
프로젝트 루트의 `.env`에 서버 주소를 설정합니다. 앱 시작 시 이 파일을 로드하며,
값이 비어 있으면 기본 주소 `http://192.168.100.3:33210`을 사용합니다.

```dotenv
MEDIA_TAG_BASE_URL=http://192.168.100.3:33210
```

`.env`는 Flutter 에셋으로 포함되므로 빌드 전에 파일이 있어야 합니다. 공개되는 웹 에셋이므로
비밀 값은 넣지 마세요.

서버는 Flutter Web 주소의 CORS 요청을 허용해야 합니다. 첨부 파일은 응답의 `content_url`로 읽습니다.

proto를 갱신한 뒤 저장소 루트에서 코드를 다시 생성합니다. `dart`, `buf`가 PATH에 있어야
하며 `flutter pub get`을 먼저 실행해야 합니다.

```bash
flutter pub get
buf generate
```

출력 경로는 `lib/src/data/datasources/generated/`입니다. 생성 코드는 직접 수정하지 않습니다.

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
