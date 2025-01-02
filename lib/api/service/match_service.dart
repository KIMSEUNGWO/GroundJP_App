
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/pipe_buffer.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/component/secure_strage.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/search_condition.dart';
import 'package:intl/intl.dart';

class MatchService extends PipeBuffer<MatchService> {

  static final MatchService instance = MatchService();
  MatchService();

  Future<List<MatchView>> search(SearchCondition condition) async {

    String queryParam = '?date=${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(condition.date)}';
    if (condition.region != null && condition.region != Region.ALL) {
      queryParam += '&region=${condition.region!.name}';
    }
    if (condition.sexType != null) {
      queryParam += '&sex=${condition.sexType!.name}';
    }
    final response = await ApiService.instance.get(
      uri: '/api/search/match$queryParam',
    );
    if (response.resultCode == ResultCode.OK) {
      return List<MatchView>.from(response.data.map( (x) => MatchView.fromJson(x)));
    } else {
      return [];
    }
  }

  Future<ResponseResult> getMatch({required int matchId}) async {
    return await ApiService.instance.get(
      uri: '/api/match/$matchId',
      token: await SecureStorage.instance.readAccessToken(),
    );
  }

  Future<List<MatchView>> getMatchesSoon() async {
    String? token = await SecureStorage.instance.readAccessToken();
    if (token == null) return [];

    final response = await ApiService.instance.get(
      uri: '/api/user/matches',
      token: token,
    );
    if (response.resultCode == ResultCode.OK) {
      return List<MatchView>.from(response.data.map((x) => MatchView.fromJson(x)));
    } else {
      return [];
    }
  }

  @override
  MatchService getService() {
    return this;
  }



}