

import 'dart:convert';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/service/pipe_buffer.dart';
import 'package:groundjp/component/secure_strage.dart';

class OrderService extends PipeBuffer<OrderService> {

  static final OrderService instance = OrderService();
  OrderService();

  Future<ResponseResult> getOrderSimp({required int matchId}) async {
    return await ApiService.instance.get(
      uri: '/api/order/match/$matchId',
      token: await SecureStorage.instance.readAccessToken(),
    );
  }

  Future<ResponseResult> postOrder({required int matchId, required int? couponId}) async {
    Map<String, String> body = {'matchId' : '$matchId'};
    if (couponId != null) body.addAll({'couponId' : '$couponId'});
    return await ApiService.instance.post(
      uri: '/api/order',
      token: await SecureStorage.instance.readAccessToken(),
      header: ApiService.contentTypeJson,
      body: jsonEncode(body)
    );
  }

  Future<ResponseResult> cancelOrder({required int matchId}) async {
    return await ApiService.instance.post(
      uri: '/cancel',
      token: await SecureStorage.instance.readAccessToken(),
      header: ApiService.contentTypeJson,
      body: jsonEncode({"matchId" : matchId}),
    );
  }

  @override
  OrderService getService() {
    return this;
  }
}