
import 'package:groundjp/api/domain/result_code.dart';

class ResponseResult {

  final ResultCode resultCode;
  final dynamic data;

  ResponseResult.fromJson(Map<String, dynamic> json) :
    resultCode = ResultCode.valueOf(json['result']),
    data = json['data'];

  ResponseResult(this.resultCode, this.data);
}

