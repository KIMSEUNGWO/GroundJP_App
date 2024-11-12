
import 'package:groundjp/domain/field/address.dart';

class OrderSimp {

  final String title;
  final int totalPrice;
  final int matchHour;

  final Address address;
  final DateTime matchDate;

  OrderSimp.fromJson(Map<String, dynamic> json):
    title = json['title'],
    matchHour = json['matchHour'],
    totalPrice = json['totalPrice'],
    address = Address.fromJson(json['address']),
    matchDate = DateTime.parse(json['matchDate']);

  OrderSimp({
    required this.title,
    required this.totalPrice,
    required this.matchHour,
    required this.address,
    required this.matchDate});
}