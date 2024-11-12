import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentlyMatchNotifier extends StateNotifier<List<MatchView>> {
  RecentlyMatchNotifier() : super([]);

  add(MatchView data) {
    Set<MatchView> set = {data, ...state};
    state = set.toList();
  }
  remove(MatchView data) {
    state = state.where((item) => item != data).toList();
  }

  List<MatchView> get() {
    return state;
  }

  length() {
    return state.length;
  }

  MatchView index(int idx) {
    return state[idx];
  }

  bool isEmpty() {
    return state.isEmpty;
  }

  void removeAll() {
    state = [];
  }

}

final recentlyMatchNotifier = StateNotifierProvider<RecentlyMatchNotifier, List<MatchView>>((ref) => RecentlyMatchNotifier());