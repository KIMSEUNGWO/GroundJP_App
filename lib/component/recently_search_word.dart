
import 'package:groundjp/component/local_storage.dart';

class RecentlySearchWord {

  Set<String> _words = {};

  init() {
    Set<String> words = Set.of(LocalStorage.instance.getRecentlySearchWords());
    _words.addAll(words);
  }

  addWord(String word) {
      _words = {word, ..._words};
  }
  deleteWord(String word) {
      _words.remove(word);
  }
  deleteAllWord() {
    _words.clear();
  }

  List<String> toList() {
    return _words.toList();
  }

  bool isNotEmpty() {
    return _words.isNotEmpty;
  }

}