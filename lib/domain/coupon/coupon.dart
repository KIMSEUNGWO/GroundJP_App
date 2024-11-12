
class Coupon {

  final int couponId;
  final String title;
  final int per;
  final DateTime expireDate;

  Coupon.fromJson(Map<String, dynamic> json):
    couponId = json['couponId'],
    title = json['title'],
    expireDate = DateTime.parse(json['expireDate']),
    per = json['per'];

  Coupon(this.couponId, this.title, this.per, this.expireDate);
}