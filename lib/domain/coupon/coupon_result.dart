
class CouponResult {

  final String title;
  final int discount;

  CouponResult.fromJson(Map<String, dynamic> json):
    title = json['title'],
    discount = json['discount'];

  CouponResult(this.title, this.discount);
}