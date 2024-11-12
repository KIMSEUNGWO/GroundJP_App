
import 'package:groundjp/component/secure_strage.dart';

class HeaderHelper {

  static const HeaderHelper instance = HeaderHelper();
  const HeaderHelper();

  static const Map<String, String> _defaultHeader = {
    "App-Authorization" : "NnJtQTdJcTU3SnF3N0tleDdLZXg2NmVv",
  };
  Future<Map<String, String>> _getAuthorization() async {
    return {"Authorization" : "Bearer ${await SecureStorage.instance.readAccessToken()}"};
  }

  getHeaders(Map<String, String> requestHeader, bool authorization, Map<String, String>? header) async {
    requestHeader.addAll(_defaultHeader);
    if (authorization) requestHeader.addAll(await _getAuthorization());
    if (header != null) requestHeader.addAll(header);
  }
}