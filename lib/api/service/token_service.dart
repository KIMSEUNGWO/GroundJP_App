
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/secure_strage.dart';

class TokenService {

  static const TokenService instance = TokenService();
  const TokenService();

  Future<String?> refreshingAccessToken() async {
    final refreshToken = await SecureStorage.instance.readRefreshToken();
    if (refreshToken == null) return null;

    final response = await ApiService.instance.post(
      uri: '/api/social/token',
      token: refreshToken,
      header: ApiService.contentTypeJson,
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.instance.saveAccessToken(response.data);
      String? accessToken = await SecureStorage.instance.readAccessToken();
      print('Refreshing AccessToken');
      print('새로 발급받은 AccessToken : $accessToken');
      return accessToken;
    }
    return null;
  }
}