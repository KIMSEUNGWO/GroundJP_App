
import 'package:groundjp/component/region_data.dart';

class Address {
   
  final String address;
  final Region region;
  final String link;

  Address.fromJson(Map<String, dynamic> json):
    address = json['address'],
    region = Region.findByName(json['region']),
    link = json['link'];

  Address(this.address, this.region, this.link);
}