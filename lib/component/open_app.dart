
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/domain/cash/kakao_ready_response.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenApp {

  // 테스트용
  static const OpenApp instance = OpenApp();
  const OpenApp();

  openMaps({required String link}) async {

    String openApp = 'comgooglemaps://';
    // await launchUrl(Uri.parse(openApp));
    Uri googleMap = Uri.parse(link);
    if (await canLaunchUrl(googleMap)) {
      await launchUrl(googleMap);
      return;
    }

  }

  kakaoOpenUrl(BuildContext context, KakaoReady kakao) async {
    if (Platform.isAndroid && await canLaunchUrl(Uri.parse(kakao.android_app_scheme))) {
      await launchUrl(Uri.parse(kakao.android_app_scheme));
      return;
    } else if (Platform.isIOS && await canLaunchUrl(Uri.parse(kakao.ios_app_scheme))) {
      await launchUrl(Uri.parse(kakao.ios_app_scheme));
      return;
    } else {
      if (context.mounted) {
        Alert.of(context).message(
          message: '카카오톡이 설치되어있지 않습니다.'
        );
      }
    }
  }

  _google(double lat, double lng) {
    return Uri.parse('https://maps.app.goo.gl/YmMQvP82ZRiKgxcF7');
    if (Platform.isIOS) {
      return Uri.parse('comgooglemaps://?q=$lat,$lng');
    } else {
      return Uri.parse('google.navigation:q=$lat,$lng');
    }
  }

  _apple(double lat, double lng) {
    return Uri.parse('maps://?q=$lat,$lng');
  }
}
