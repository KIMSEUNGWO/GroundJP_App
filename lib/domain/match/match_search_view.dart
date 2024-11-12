
import 'package:groundjp/domain/enums/match_enums.dart';

class MatchView {

  final int matchId;
  final MatchStatus matchStatus;
  final String title;
  final DateTime matchDate;
  final MatchData matchData;

  MatchView.fromJson(Map<String, dynamic> json):
    matchId = json['matchId'],
    matchStatus = MatchStatus.valueOf(json['matchStatus']),
    title = json['title'],
    matchDate = DateTime.parse(json['matchDate']),
    matchData = MatchData.fromJson(json['matchData']);

  MatchView(
      this.matchId, this.matchStatus, this.title, this.matchDate, this.matchData);
}