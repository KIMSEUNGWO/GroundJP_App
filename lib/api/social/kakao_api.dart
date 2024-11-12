

import 'package:groundjp/api/social/abstract_social_api.dart';
import 'package:groundjp/component/secure_strage.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoApi implements SocialAPI {

  @override
  Future<SocialResult?> login() async {
    final UserApi api = UserApi.instance;
    try {
      late OAuthToken authToken;
      if (await isKakaoTalkInstalled()) {
        try {
          authToken = await api.loginWithKakaoTalk();
        } catch (e) {
          // 로그인 취소 한경우 null 반환
          if (e is PlatformException && e.code == 'CANCELED') {
            return null;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          authToken = await api.loginWithKakaoAccount();
        }
      } else {
        authToken = await api.loginWithKakaoAccount();
      }

      User kakaoUser = await api.me();
      return SocialResult(
        socialId: '${kakaoUser.id}',
        provider: SocialProvider.KAKAO,
        accessToken: authToken.accessToken,
      );
    } catch (e) {
      print('카카오계정으로 로그인 실패 $e');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      SecureStorage.instance.removeAllByToken();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> refreshToken() {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyAccessToken() {
    throw UnimplementedError();
  }

}