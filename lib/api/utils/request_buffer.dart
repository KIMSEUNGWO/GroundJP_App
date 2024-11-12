
import 'package:groundjp/component/constant.dart';

class RequestBuffer {

  List<DateTime> _requestTimestamps = [];

  static RequestBuffer instance = RequestBuffer();
  RequestBuffer();

  // GET 요청을 허용할지 여부를 반환하는 메서드
  bool allowRequest() {
    final now = DateTime.now();

    // 2초가 지난 오래된 요청들을 제거
    _requestTimestamps = _requestTimestamps.where((timestamp) {
      return now.difference(timestamp) < Constant.REQUEST_TIME_DURATION;
    }).toList();

    // 현재까지 저장된 요청의 개수가 허용된 최대 요청 수 이하인지 확인
    if (_requestTimestamps.length < Constant.REQUEST_MAX_REQUESTS) {
      _requestTimestamps.add(now);
      return true;  // 요청 허용
    } else {
      return false; // 요청 거절
    }
  }
}