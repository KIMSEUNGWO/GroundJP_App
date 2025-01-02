
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/token_service.dart';
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/api/social/abstract_social_api.dart';
import 'package:groundjp/api/social/kakao_api.dart';
import 'package:groundjp/api/social/line_api.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/domain/user/user_profile.dart';
import 'package:groundjp/notifier/coupon_notifier.dart';
import 'package:groundjp/notifier/favorite_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<UserProfile?> {
  UserNotifier() : super(null);

  SocialAPI? socialAPI;
  final Map<SocialProvider, SocialAPI> _map = {
    SocialProvider.LINE : LineAPI(),
    SocialProvider.KAKAO : KakaoApi(),
  };

  void setProfile(UserProfile newProfile) {
    state = newProfile;
  }

  Future<ResponseResult> login(BuildContext context, WidgetRef ref, SocialProvider provider) async {
    socialAPI = _map[provider];
    final socialResult = await socialAPI!.login();
    if (socialResult == null) {
      state = null;
      return ResponseResult(ResultCode.SOCIAL_LOGIN_FAILD, null);
    }
    final result = await UserService.instance.login(socialResult);
    if (result == ResultCode.REGISTER) {
      return ResponseResult(result, socialResult);
    }
    await readUser(ref);
    return ResponseResult(result, null);
  }

  Future<bool> register(WidgetRef ref, {required SexType sex, required DateTime birth, required SocialResult social}) async {
    final response = await UserService.instance.register(
      sex: sex,
      birth: birth,
      social: social,
    );
    if (response == ResultCode.OK) {
      readUser(ref);
      return true;
    }
    return false;
  }

  void logout(WidgetRef ref) async {
    await UserService.instance.logout();

    ref.read(favoriteNotifier.notifier).logout();
    ref.read(couponNotifier.notifier).logout();

    socialAPI = socialAPI ?? _map[state!.provider];
    socialAPI!.logout();
    state = null;
  }

  bool has() {
    return state != null;
  }

  init(WidgetRef ref) async {
    state = await UserService.instance.getProfile();
    print('user : ${state?.nickname}');
    ref.read(favoriteNotifier.notifier).init();
    ref.read(couponNotifier.notifier).init();
  }

  readUser(WidgetRef ref) async {
      state = await UserService.instance.getProfile();
      ref.read(favoriteNotifier.notifier).init();
      if (state == null) {
        logout(ref);
      }
  }

  refreshCash() async {
    final result = await UserService.instance.getCash();
    if (result.resultCode == ResultCode.OK) {
      state?.cash = result.data;
      state = UserProfile.clone(state!);
    }
  }

  Image? getImage() {
    return state?.image;
  }

  UserProfile? get() {
    return state;
  }

  int getId() {
    return state!.id;
  }

  int getCash() {
    return state!.cash;
  }


}

final loginProvider = StateNotifierProvider<UserNotifier, UserProfile?>((ref) => UserNotifier(),);