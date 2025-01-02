import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class Constant {

  static const String ACCESS_TOKEN = 'social_api_accessToken';
  static const String REFRESH_TOKEN = 'social_api_refreshToken';
}

class SecureStorage {

  final FlutterSecureStorage storage;
  static const SecureStorage instance = SecureStorage();

  const SecureStorage():
    storage = const FlutterSecureStorage();

  // 리프레시 토큰 저장
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      // print('[SECURE_STORAGE] saveRefreshToken : $refreshToken');
      await storage.write(key: Constant.REFRESH_TOKEN, value: refreshToken);
    } catch (e) {
      print('[ERROR] [SECURE_STORAGE] Refresh Token 저장 실패 !!! :  $e');
    }
  }

  // 리프레시 토큰 블러오기
  Future<String?> readRefreshToken() async {
    try {
      final refreshToken = await storage.read(key: Constant.REFRESH_TOKEN);
      // print('[SECURE_STORAGE] readRefreshToken: $refreshToken');
      return refreshToken;
    } catch (e) {
      print("[ERROR] [SECURE_STORAGE] RefreshToken 불러오기 실패 !!! : $e");
      return null;
    }
  }

  void removeAllByToken() {
    storage.delete(key: Constant.ACCESS_TOKEN);
    storage.delete(key: Constant.REFRESH_TOKEN);
    // print('[SECURE_STORAGE] deleteAllByToken !!');
  }

  // 엑세스 토큰 저장
  Future<void> saveAccessToken(String accessToken) async {
    try {
      // print('[SECURE_STORAGE] saveAccessToken: $accessToken');
      await storage.write(key: Constant.ACCESS_TOKEN, value: accessToken);
    } catch (e) {
      print("[ERROR] [SECURE_STORAGE] AccessToken 저장 실패: $e");
    }
  }

  // 에세스 토큰 불러오기
  Future<String?> readAccessToken() async {
    try {
      final accessToken = await storage.read(key: Constant.ACCESS_TOKEN);
      // print('[SECURE_STORAGE] readAccessToken: $accessToken');
      return accessToken;
    } catch (e) {
      print("[ERROR] [SECURE_STORAGE] AccessToken 불러오기 실패: $e");
      return null;
    }
  }
}