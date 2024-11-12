
import 'package:flutter/material.dart';
import 'package:groundjp/component/datetime_formatter.dart';
import 'package:groundjp/domain/board/board_simp.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/component/user_profile_wiget.dart';
import 'package:groundjp/widgets/pages/poppages/board_detail_page.dart';

class BoardWidget extends StatelessWidget {

  final BoardSimp boardSimp;
  final Function(int boardId)? notExistsEvent;
  const BoardWidget({super.key, required this.boardSimp, required this.notExistsEvent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BoardDetailWidget(
            boardId: boardSimp.boardId,
            notExistsEvent: notExistsEvent,
          );
        },));
      },
      child: CustomContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserProfileWidget(
                  diameter: 25,
                  image: boardSimp.user.profile,
                ),
                const SizedBox(width: 10,),
                Text(boardSimp.user.nickname,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SpaceHeight(10),
            Text(boardSimp.title,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SpaceHeight(5),
            Text('${boardSimp.region.ko} · ${DateTimeFormatter.formatDate(boardSimp.createDate)}'),
          ],
        ),
      ),
    );
  }
}
