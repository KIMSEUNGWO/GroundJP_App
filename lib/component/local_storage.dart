import 'package:groundjp/component/region_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  final SharedPreferences _storage;

  static late LocalStorage instance;
  LocalStorage._(this._storage);

  static Future<LocalStorage> initInstance() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    instance = LocalStorage._(sharedPreferences);
    return instance;
  }

  Region findByRegion() {
    String? regionName = _storage.getString(LocalStorageKey.REGION.name);
    return Region.findByName(regionName);
  }

  saveByRegion(Region region) {
    _storage.setString(LocalStorageKey.REGION.name, region.name);
  }

  List<String> getRecentlySearchWords() {
    List<String>? words = _storage.getStringList(LocalStorageKey.RECENTLY_SEARCH_WORD.name);
    return (words == null) ? [] : words;
  }

  saveByRecentlySearchWord(List<String> words) {
    if (words.length > 6) words = words.sublist(0, 6);
    _storage.setStringList(LocalStorageKey.RECENTLY_SEARCH_WORD.name, words);
  }

  bool getMatchNotification() {
    bool? isOn = _storage.getBool(LocalStorageKey.MATCH_NOTIFICATION.name);
    if (isOn == null) {
      saveMatchNotification(true);
      return true;
    }
    return isOn;
  }

  saveMatchNotification(bool isOn) {
    _storage.setBool(LocalStorageKey.MATCH_NOTIFICATION.name, isOn);
  }


}

enum LocalStorageKey {

  REGION,
  RECENTLY_SEARCH_WORD,
  MATCH_NOTIFICATION

}