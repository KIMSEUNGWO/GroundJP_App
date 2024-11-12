
import 'package:groundjp/component/svg_icon.dart';
import 'package:flutter/material.dart';

enum Payment {

  LINE(Color(0xFF08BF5B), 'line', '라인페이'),
  KAKAO(Color(0xFFF3DA01), 'kakao', '카카오페이'),
  APPLE(Colors.black, 'apple', '애플페이');

  final Color backgroundColor;
  final String url;
  final String ko;

  const Payment(this.backgroundColor, this.url, this.ko);

  SIcon getLogo() {
    return switch (this) {
      Payment.LINE => SIcon.linePay,
      Payment.KAKAO => SIcon.kakaoPay,
      Payment.APPLE => SIcon.applePay,
    };
  }
}