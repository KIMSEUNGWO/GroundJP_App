import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:groundjp/notifier/favorite_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteIconButtonWidget extends ConsumerWidget {
  final FieldSimp fieldSimp;
  final double? size;
  final bool disabled;
  final bool readOnly;

  const FavoriteIconButtonWidget({super.key, required this.fieldSimp, this.size, this.disabled = false, this.readOnly = false});

  bool _has(List<FieldSimp> state, int fieldId) {
    for (var fieldSimp in state) {
      if (fieldSimp.fieldId == fieldId) return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasLogin = ref.watch(loginProvider.notifier).has();
    if (!hasLogin) return const SizedBox();

    List<FieldSimp> state = ref.watch(favoriteNotifier);
    bool isOn = _has(state, fieldSimp.fieldId);

    return (!isOn && disabled)
      ? const SizedBox()
      : GestureDetector(
          onTap: () async {
            if (readOnly) return;
            await ref.read(favoriteNotifier.notifier).toggle(fieldSimp);
          },
          child: SvgIcon.asset(
            sIcon: isOn ? SIcon.bookmarkFill : SIcon.bookmark,
            style: SvgIconStyle(
              height: size,
              width: size,
            ),
          ),
        );
  }
}
