
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/secure_strage.dart';

class TokenService {

  static const TokenService instance = TokenService();
  const TokenService();

  Future<bool> _checkAccessToken() async {
    final accessToken = await SecureStorage.instance.readAccessToken();
    if (accessToken == null) return false;
    final response = await ApiService.instance.get(uri: '/api/accessToken', authorization: true);
    return response.resultCode == ResultCode.OK;
  }

  Future<bool> _refreshingAccessToken() async {
    final refreshToken = await SecureStorage.instance.readRefreshToken();
    if (refreshToken == null) return false;

    final response = await ApiService.instance.post(
      uri: '/api/social/token',
      authorization: true,
      header: ApiService.contentTypeJson,
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.instance.saveAccessToken(response.data['accessToken']);
      await SecureStorage.instance.saveRefreshToken(response.data['refreshToken']);
      print('Refreshing AccessToken');
      return true;
    }
    return false;
  }

  Future<bool> readUser() async {
    return (await _checkAccessToken() || await _refreshingAccessToken());
  }
}