
enum ResultCode {
  OK,

  NOT_AUTHENTICATION, // 권한 없음

  MATCH_NOT_EXISTS,
  FIELD_NOT_EXISTS,
  ORDER_NOT_EXISTS,
  BOARD_NOT_EXISTS,

  INVALID_DATA,
  UNKOWN, SOCIAL_LOGIN_FAILD, REGISTER,
  ACCESS_TOKEN_REQUIRE, // 로그인하지 않은 회원이나 토근이 유효하지 않은경우


  // 주문 예외
  ALREADY_JOIN, // 이미 신청한 매치에 다시 신청요청이 올 경우
  COUPON_NOT_EXISTS, // 쿠폰이 존재하지 않은 경우
  INVALID_REQUEST, // 자신의 쿠폰이 아닌 경우 (데이터 조작 의심 예외)
  COUPON_ALREADY_USE, // 이미 사용한 쿠폰인 경우
  COUPON_EXPIRE, // 쿠폰이 만료된 경우
  NOT_MATCHED_SEX, // 경기 성별 제한조건에 해당되는 경우
  NOT_ENOUGH_CASH, // 캐시가 부족한 경우
  ALREADY_CLOSED, // 이미 경기가 마감된 경우

  BAN_WORD_INCLUDE, // 금지된 단어가 포함된 경우

  ;

  static ResultCode valueOf(String errorCode) {
    List<ResultCode> errorCodes = ResultCode.values;

    for (var error in errorCodes) {
      if (error.name == errorCode) return error;
    }
    return ResultCode.UNKOWN;
  }

  bool hasOrderError() {
    return this == ALREADY_JOIN
        || this == COUPON_NOT_EXISTS
        || this == INVALID_REQUEST
        || this == COUPON_ALREADY_USE
        || this == COUPON_EXPIRE
        || this == NOT_MATCHED_SEX
        || this == NOT_ENOUGH_CASH
        || this == ALREADY_CLOSED;
  }

  String orderErrorMessage() {
    if (this == ALREADY_JOIN) return '이미 참여한 경기입니다.';
    if (this == COUPON_NOT_EXISTS) return '존재하지 않은 쿠폰입니다.';
    if (this == INVALID_REQUEST) return '잘못된 요청입니다.';
    if (this == COUPON_ALREADY_USE) return '이미 사용된 쿠폰입니다.';
    if (this == COUPON_EXPIRE) return '만료된 쿠폰입니다.';
    if (this == NOT_MATCHED_SEX) return '성별이 일치하지 않습니다.';
    if (this == NOT_ENOUGH_CASH) return '캐시가 부족합니다.';
    if (this == ALREADY_CLOSED) return '경기가 마감되었습니다.';
    return '';
  }
}
