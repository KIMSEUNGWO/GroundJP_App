

import 'package:flutter/material.dart';
import 'package:groundjp/api/utils/request_buffer.dart';
import 'package:groundjp/component/alert.dart';

abstract class PipeBuffer<T> {


  Future<R?> buffer<R>(BuildContext context, Future<R?> Function(T) service ) async {
    bool canRequest = RequestBuffer.instance.allowRequest();
    if (canRequest) {
      return await service(getService());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Alert.of(context).message(message: '요청이 너무 빠릅니다. 잠시 후에 시도해주세요.');
      },);
      return null;
    }
  }

  T getService();


}