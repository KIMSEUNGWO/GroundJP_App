
import 'package:groundjp/domain/coupon/coupon_result.dart';

class OrderResult {

  final int totalPrice;
  final CouponResult? coupon;
  final int finalPrice;
  final int remainCash;

  OrderResult.fromJson(Map<String, dynamic> json):
    totalPrice = json['totalPrice'],
    coupon = json['coupon'] != null ? CouponResult.fromJson(json['coupon']) : null,
    finalPrice = json['finalPrice'],
    remainCash = json['remainCash'];

  OrderResult(this.totalPrice, this.coupon, this.finalPrice, this.remainCash);
}