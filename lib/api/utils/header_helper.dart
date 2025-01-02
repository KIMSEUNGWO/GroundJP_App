import 'package:groundjp/component/secure_strage.dart';

class HeaderHelper {
  static const HeaderHelper instance = HeaderHelper();

  const HeaderHelper();

  static const Map<String, String> defaultHeader = {
    "App-Authorization": "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
  };

  getAuthorization(String token) {
    return {"Authorization": "Bearer $token"};
  }

  Map<String, String> getHeaders(Map<String, String> requestHeader, String? token, Map<String, String>? header) {
    Map<String, String> map = {};
    map.addAll(defaultHeader);
    if (token != null) map.addAll(getAuthorization(token));
    if (header != null) map.addAll(header);
    return map;
  }
}
