
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteNotifier extends StateNotifier<List<FieldSimp>> {
  FavoriteNotifier() : super([]);

  init() async {
    state = await UserService.instance.getFavorites();
  }

  logout() {
    state = [];
  }
  
  bool has(int fieldId) {
    for (var fieldSimp in state) {
      if (fieldSimp.fieldId == fieldId) return true;
    }
    return false;
  }

  toggle(FieldSimp fieldSimp) {
    if (has(fieldSimp.fieldId)) {
      _remove(fieldSimp.fieldId);
    } else {
      _add(fieldSimp);
    }
  }

  _add(FieldSimp fieldSimp) async {
    ResultCode resultCode = await UserService.instance.editFavorite(fieldSimp.fieldId, true);
    if (resultCode == ResultCode.OK) {
      Set<FieldSimp> set = {fieldSimp, ...state.toSet()};
      state = set.toList();
    }
  }
  _remove(int fieldId) async {
    ResultCode resultCode = await UserService.instance.editFavorite(fieldId, false);
    if (resultCode == ResultCode.OK) {
      state.removeWhere((field) => field.fieldId == fieldId);
      state = state.toList();
    }
  }


}

final favoriteNotifier = StateNotifierProvider<FavoriteNotifier, List<FieldSimp>>((ref) => FavoriteNotifier());