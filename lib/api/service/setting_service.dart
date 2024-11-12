
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/pipe_buffer.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/domain/notice.dart';

class SettingService extends PipeBuffer<SettingService> {

  static final SettingService instance = SettingService();
  SettingService();

  Future<List<Notice>> getPageableNotice(Pageable pageable) async {
    final response = await ApiService.instance.get(
      uri: '/api/search/notice?&${pageable.getParam()}',
      authorization: false,
    );
    if (response.resultCode == ResultCode.OK) {
      return List<Notice>.from(response.data.map( (x) => Notice.fromJson(x)));
    } else {
      return [];
    }
  }

  @override
  SettingService getService() {
    return this;
  }

}