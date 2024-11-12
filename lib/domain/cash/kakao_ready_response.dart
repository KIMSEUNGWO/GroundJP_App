
class KakaoReady {

  final String tid;
  final String next_redirect_pc_url;
  final String next_redirect_app_url;
  final String next_redirect_mobile_url;
  final String ios_app_scheme;
  final String android_app_scheme;
  final String partner_order_id;
  final String partner_user_id;

  KakaoReady.fromJson(Map<String, dynamic> json):
    tid = json['tid'],
    ios_app_scheme = json['ios_app_scheme'],
    partner_order_id = json['partner_order_id'],
    partner_user_id = json['partner_user_id'],
    android_app_scheme = json['android_app_scheme'],
    next_redirect_pc_url = json['next_redirect_pc_url'],
    next_redirect_mobile_url = json['next_redirect_mobile_url'],
    next_redirect_app_url = json['next_redirect_app_url'];

  String generateParams(String url) {
    if (!url.contains('?')) url += '?';
    return '$url&tid=$tid&partner_order_id=$partner_order_id&partner_user_id=$partner_user_id';
  }
}