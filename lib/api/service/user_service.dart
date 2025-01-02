
import 'dart:convert';
import 'dart:async';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/pipe_buffer.dart';
import 'package:groundjp/component/secure_strage.dart';
import 'package:groundjp/domain/cash/receipt.dart';
import 'package:groundjp/domain/coupon/coupon.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/domain/user/user_profile.dart';
import 'package:intl/intl.dart';

class UserService extends PipeBuffer<UserService> {

  static final UserService instance = UserService();
  UserService();

  Future<ResultCode> login(SocialResult result) async {
    final response = await ApiService.instance.post(
      uri: '/api/social/login',
      header: ApiService.contentTypeJson,
      body: jsonEncode({
        "socialId" : result.socialId,
        "provider" : result.provider.name,
        "accessToken" : result.accessToken
      }),
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.instance.saveAccessToken(response.data['accessToken']);
      await SecureStorage.instance.saveRefreshToken(response.data['refreshToken']);
      print('LINE LOGIN SUCCESS !!!');
    }
    return response.resultCode;
  }

  logout() async {
    await ApiService.instance.delete(
      uri: '/api/social/logout',
      header: ApiService.contentTypeJson,
      body: await SecureStorage.instance.readRefreshToken()
    );
  }


  Future<UserProfile?> getProfile() async {
    String? accessToken = await SecureStorage.instance.readAccessToken();
    if (accessToken == null) return null;
    final response = await ApiService.instance.get(
      uri: '/api/user/profile',
      token: accessToken,
    );



    if (response.resultCode == ResultCode.OK) {
      return UserProfile.fromJson(response.data);
    }
    return null;
  }

  Future<ResultCode> register({required SexType sex, required DateTime birth, required SocialResult social}) async {

    final response = await ApiService.instance.post(
        uri: '/api/social/register',
        header: ApiService.contentTypeJson,
        body: jsonEncode({
          "sex" : sex.name,
          "birth" : DateFormat('yyyy-MM-dd').format(birth),
          "socialId" : social.socialId,
          "provider" : social.provider.name,
          "accessToken" : social.accessToken
        })
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.instance.saveAccessToken(response.data['accessToken']);
      await SecureStorage.instance.saveRefreshToken(response.data['refreshToken']);
      print('REGISTER SUCCESS !!!');
    }
    return response.resultCode;
  }

  Future<ResponseResult> getCash() async {
    return await ApiService.instance.get(
      uri: '/api/user/cash',
      token: await SecureStorage.instance.readAccessToken(),
    );
  }

  Future<List<Receipt>> getReceipt() async {
    final response = await ApiService.instance.get(
      uri: '/api/user/receipt',
      token: await SecureStorage.instance.readAccessToken(),
    );
    if (response.resultCode == ResultCode.OK) {
      return List<Receipt>.from(response.data.map( (x) => Receipt.fromJson(x) ));
    } else {
      return [];
    }
  }

  Future<Map<int, List<MatchView>>> getHistory(DateTime date) async {
    final String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date);

    final response = await ApiService.instance.get(
      uri: '/api/user/history?date=$formattedDate',
      token: await SecureStorage.instance.readAccessToken(),
    );
    if (response.resultCode == ResultCode.OK) {
      Map<int, List<MatchView>> result = {};

      response.data.forEach((key, value) {
        final int intKey = int.parse(key);
        final List<MatchView> matchList = (value as List)
            .map((item) => MatchView.fromJson(item))
            .toList();
        result[intKey] = matchList;
      });

      return result;
    } else {
      return {};
    }
  }

  Future<List<FieldSimp>> getFavorites() async {
    String? accessToken = await SecureStorage.instance.readAccessToken();
    if (accessToken == null) return [];

    final response = await ApiService.instance.get(
      uri: '/api/user/favorite',
      token: accessToken,
    );
    if (response.resultCode == ResultCode.OK) {
      return List<FieldSimp>.from(response.data.map((x) => FieldSimp.fromJson(x)));
    } else {
      return [];
    }
  }

  void test() async {
    final response = await ApiService.instance.get(
      uri: '/test',
      token: await SecureStorage.instance.readAccessToken(),
    );
  }

  Future<ResultCode> editFavorite(int fieldId, bool toggle) async {
    String? accessToken = await SecureStorage.instance.readAccessToken();
    if (accessToken == null) return ResultCode.UNAUTHRIZED;

    final response = await ApiService.instance.post(
        uri: '/api/user/favorite',
        token: await SecureStorage.instance.readAccessToken(),
        header: ApiService.contentTypeJson,
        body: jsonEncode({
          "fieldId" : fieldId,
          "toggle" : toggle,
        })
    );
    return response.resultCode;
  }

  Future<List<Coupon>> getCoupons() async {
    final response = await ApiService.instance.get(
      uri: '/api/user/coupon',
      token: await SecureStorage.instance.readAccessToken(),
    );
    if (response.resultCode == ResultCode.OK) {
      return List<Coupon>.from(response.data.map((x) => Coupon.fromJson(x)));
    } else {
      return [];
    }
  }

  Future<bool> distinctNickname(String nickname) async {
    String encodedNickname = Uri.encodeComponent(nickname);
    final response = await ApiService.instance.get(
      uri: '/api/user/distinct/nickname?nickname=$encodedNickname',
      token: await SecureStorage.instance.readAccessToken(),
    );
    if (response.resultCode == ResultCode.OK) {
      return response.data;
    } else {
      return true;
    }
  }

  @override
  UserService getService() {
    return this;
  }

}