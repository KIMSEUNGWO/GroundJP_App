
import 'package:groundjp/component/region_data.dart';

class FieldSimp {

  final int fieldId;
  final String title;
  final Region region;
  final String address;

  FieldSimp.fromJson(Map<String, dynamic> json):
    fieldId = json['fieldId'],
    title = json['title'],
    region = Region.valueOf(json['region']) ?? Region.ALL,
    address = json['address'];

  FieldSimp(this.fieldId, this.title, this.address, this.region);

  @override
  bool operator ==(Object other) =>
      identical(this, other)
        || other is FieldSimp
        && runtimeType == other.runtimeType
        && fieldId == other.fieldId;

  @override
  int get hashCode => fieldId.hashCode;
}