import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/web.dart' as connect_web;

/// 기본 `same-origin`. `credentials: include`는 서버 ACAO가 `*`일 때 CORS에 막힌다.
/// 교차 출처(localhost → tks)는 Login 응답 token을 Bearer로 붙인다.
/// 같은 출처(예: tks에서 서빙)면 쿠키가 자동으로 실리고 Bearer도 함께 간다.
connect.HttpClient createDashboardHttpClient() =>
    connect_web.createHttpClient();
