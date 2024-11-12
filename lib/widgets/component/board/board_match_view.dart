
import 'package:flutter/material.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/match_extra_data.dart';
import 'package:groundjp/widgets/component/match_status_box.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/match_detail_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoardMatchViewWidget extends StatelessWidget {

  final MatchView match;
  const BoardMatchViewWidget({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MatchDetailWidget(matchId: match.matchId);
        },));
      },
      child: CustomContainer(
        backgroundColor: Theme.of(context).colorScheme.onTertiary,
        child: Column(
          children: [
            Row(
              children: [
                MatchStatusWidget(matchStatus: match.matchStatus),
                const SpaceWidth(10,),
                Expanded(
                  child: Text(match.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 14.sp,
                )
              ],
            ),
            const SpaceHeight(8),
            MatchExtraDataWidget(matchData: match.matchData),
          ],
        ),
      )
    );
  }
}
