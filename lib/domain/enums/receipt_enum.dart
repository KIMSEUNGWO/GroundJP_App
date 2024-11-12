
enum ReceiptType {

  USE,
  CHARGE,
  CANCEL,
  REFUND;

  static ReceiptType? valueOf(String data) {
    List<ReceiptType> list = ReceiptType.values;
    for (var o in list) {
      if (o.name == data) return o;
    }
    return null;
  }

  static String lang(ReceiptType? data) {
    return switch (data) {
      USE => '사용',
      CHARGE => '충전',
      CANCEL => '취소',
      REFUND => '환불',
      null => '전체'
    };
  }
}