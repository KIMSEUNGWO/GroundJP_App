
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/enums/match_enums.dart';

class SearchCondition {

  final DateTime date;
  final SexType? sexType;
  final Region? region;

  SearchCondition({required this.date, required this.sexType, required this.region});

}