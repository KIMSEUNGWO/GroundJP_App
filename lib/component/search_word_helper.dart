
import 'package:groundjp/component/region_data.dart';

class SearchWordHelper {



}

class SearchWordData {

  final String word;
  final Region? region;

  SearchWordData(this.word, this.region);

  String toParam() {
    String params = 'word=$word';
    if (region != null) params += '&region=${region!.name}';
    return params;
  }

}