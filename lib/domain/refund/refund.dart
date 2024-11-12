
class Refund {

  final int payAmount;
  final int refundAmount;

  Refund.fromJson(Map<String, dynamic> json):
    payAmount = json['payAmount'],
    refundAmount = json['refundAmount'];

  Refund(this.payAmount, this.refundAmount);
}