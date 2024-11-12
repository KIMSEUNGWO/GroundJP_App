import 'package:groundjp/api/social/abstract_social_api.dart';
import 'package:groundjp/component/secure_strage.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';


class LineAPI implements SocialAPI {

  @override
  Future<SocialResult?> login() async {
    try {
      final result = await LineSDK.instance.login();
      return SocialResult(
        socialId: result.userProfile!.userId,
        provider: SocialProvider.LINE,
        accessToken: result.accessToken.value,
      );

    } on PlatformException catch(e) {
      print('LINE API : PlatformException !!!');
      print(e);
      return null;
    }

  }

  @override
  Future<void> logout() async {
    try {
      await LineSDK.instance.logout();
      SecureStorage.instance.removeAllByToken();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> verifyAccessToken() async {
    try {
      final result = await LineSDK.instance.verifyAccessToken();
    } on PlatformException catch (e) {
      print(e.message);
      // token is not valid, or any other error.
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      final result = await LineSDK.instance.refreshToken();
      print(result.value);
      // access token -> result.value
      // expires duration -> result.expiresIn
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

}
