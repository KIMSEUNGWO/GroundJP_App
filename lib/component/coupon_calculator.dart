

class CouponCalculator {

  static const CouponCalculator instance = CouponCalculator();
  const CouponCalculator();

  int discount(int price, double per) {
    return (price * per).ceil();
  }

  int total(int price, double per) {
    return price - discount(price, per);
  }
}