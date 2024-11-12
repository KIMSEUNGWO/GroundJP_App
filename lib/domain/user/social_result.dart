
class SocialResult {

  final String socialId;
  final SocialProvider provider;
  final String accessToken;

  SocialResult({required this.socialId, required this.provider, required this.accessToken});
}

enum SocialProvider {

  LINE,
  KAKAO,
  APPLE;

  static SocialProvider? fromJson(String data) {
    for (var o in SocialProvider.values) {
      if (o.name == data.toUpperCase()) return o;
    }
    return null;
  }

}