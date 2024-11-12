import 'dart:ui';

import 'package:groundjp/component/local_storage.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/component/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegionNotifier extends StateNotifier<Region?> {
  RegionNotifier() : super(null);

  init() {
    state = LocalStorage.instance.findByRegion();
  }

  Region? get() {
    return state;
  }

  void setRegion(BuildContext context, Region newRegion) async {
    if (state == newRegion) return;
    state = newRegion;
    LocalStorage.instance.saveByRegion(newRegion);
    CustomSnackBar.instance.message(context, '지역을 변경했습니다.');
  }

  String? getLocalName(Locale locale) {
    return state?.getLocaleName(locale);
  }

}

final regionProvider = StateNotifierProvider<RegionNotifier, Region?>((ref) => RegionNotifier());