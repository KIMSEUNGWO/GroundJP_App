
enum Parking {

  FREE,
  PAID,
  NOT_AVAILABLE
  ;

  static Parking valueOf(String? data) {
    List<Parking> values = Parking.values;
    for (var o in values) {
      if (o.name == data) return o;
    }
    return Parking.NOT_AVAILABLE;
  }

  static String getName(Parking data) {
    if (data == Parking.FREE) return '무료주차';
    if (data == Parking.PAID) return '유료주차';
    return '이용불가';
  }
}

enum Shower {

  Y,
  N;

  static Shower valueOf(String? data) {
    List<Shower> values = Shower.values;
    for (var o in values) {
      if (o.name == data) return o;
    }
    return Shower.N;
  }

  static String getName(Shower data) {
    if (data == Shower.Y) return '샤워장 있음';
    return '샤워장 없음';
  }
}
enum Toilet {

  Y,
  N;

  static Toilet valueOf(String? data) {
    List<Toilet> values = Toilet.values;
    for (var o in values) {
      if (o.name == data) return o;
    }
    return Toilet.N;
  }

  static String getName(Toilet data) {
    if (data == Toilet.Y) return '화장실 있음';
    return '화장실 없음';
  }
}