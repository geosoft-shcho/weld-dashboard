import 'package:flutter/foundation.dart';

/// `POST /assets`(multipart·tus·register) metadata 디버그.
class AssetUploadDebugLog {
  AssetUploadDebugLog._();

  static void post({
    required String transport,
    required String fileName,
    required String metadata,
    required String url,
  }) {
    if (!kDebugMode) {
      return;
    }
    // ignore: avoid_print
    print(
      '[MM-UPLOAD] transport=$transport file=$fileName '
      'url=$url metadata=$metadata',
    );
  }
}
