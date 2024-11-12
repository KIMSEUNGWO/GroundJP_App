
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/domain/coupon/coupon.dart';

class CouponNotifier extends StateNotifier<List<Coupon>> {
  CouponNotifier() : super([]);

  init() async {
    state = await UserService.instance.getCoupons();
  }

  logout() {
    state = [];
  }

  List<Coupon> get() {
    return state;
  }

  int length() {
    return state.length;
  }

  void delete(Coupon? coupon) {
    if (coupon == null) return;
    state.removeWhere((c) => c.couponId == coupon.couponId,);
    state = [... state];
  }



}

final couponNotifier = StateNotifierProvider<CouponNotifier, List<Coupon>>((ref) => CouponNotifier());