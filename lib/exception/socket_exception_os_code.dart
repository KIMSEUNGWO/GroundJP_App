
enum SocketOSCode {

  CONNECTION_REFUSED(61, '서버연결이 거부되었습니다.'),
  NO_ROUTE_TO_HOST(65, '서버를 찾을 수 없습니다.'),
  UNKNOWN(0, '서버와의 연결 중 알 수 없는 오류가 발생했습니다.')
  ;

  final int errorCode;
  final String message;

  const SocketOSCode(this.errorCode, this.message);

  static SocketOSCode convert(int? errno) {
    for (var o in SocketOSCode.values) {
      if (o.errorCode == errno) return o;
    }
    return SocketOSCode.UNKNOWN;
  }

  String getMessage() {
    return '$message \n(ERROR CODE: $errorCode)';
  }

}