
import 'package:groundjp/domain/user/social_result.dart';

abstract class SocialAPI {

  Future<SocialResult?> login();
  Future<void> logout();
  Future<void> verifyAccessToken();
  Future<void> refreshToken();
}