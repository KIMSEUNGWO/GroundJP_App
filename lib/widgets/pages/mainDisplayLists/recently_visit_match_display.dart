
import 'dart:math';

import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/notifier/recently_match_notifier.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/settings_menu_form.dart';
import 'package:groundjp/widgets/pages/poppages/recently_visit_match_more_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentlyVisitMatchDisplay extends ConsumerWidget {
  const RecentlyVisitMatchDisplay({super.key});
  final int maxLine = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<MatchView> items = ref.watch(recentlyMatchNotifier);
    if (items.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('최근 본 매치',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (items.length > maxLine)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const RecentlyVisitMatchMoreWidget();
                      },));
                    },
                    child: Row(
                      children: [
                        Text('더보기',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SpaceWidth(2,),
                        Icon(Icons.arrow_forward_ios_rounded,
                          size: Theme.of(context).textTheme.bodyMedium!.fontSize,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          const SpaceHeight(10),
          Column(
            children: ListSeparatorBuilder(
              items: items
                .sublist(0, min(items.length, maxLine))
                .map((match) => MatchListWidget(match: match, formatType: DateFormatType.DATETIME,))
                .toList(),
              separator: const SpaceHeight(16),
            ).build(),
          ),
        ],
      ),
    );
  }
}
