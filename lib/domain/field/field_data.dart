
import 'package:groundjp/domain/enums/field_enums.dart';

class FieldData {

  final Parking parking;
  final Shower shower;
  final Toilet toilet;
  final int size;

  FieldData.fromJson(Map<String, dynamic> json):
    parking = Parking.valueOf(json['parking']),
    shower = Shower.valueOf(json['shower']),
    toilet = Toilet.valueOf(json['toilet']),
    size = json['size'];

  FieldData(this.parking, this.shower, this.toilet, this.size);
}