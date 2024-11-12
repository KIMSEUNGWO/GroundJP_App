
import 'package:groundjp/domain/enums/match_enums.dart';

class Statistics {

  final Map<SexType, int>? sexStatistics;

  Statistics.fromJson(Map<String, dynamic> json):
   sexStatistics = json['sexStatistics'] == null ? null :
      (json['sexStatistics'] as Map<String, dynamic>).map((key, value) =>
      MapEntry(SexType.values.byName(key), value as int));

  Statistics({required this.sexStatistics});
}