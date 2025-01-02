
import 'package:groundjp/api/service/match_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/exception/server/server_exception.dart';
import 'package:groundjp/exception/server/socket_exception.dart';
import 'package:groundjp/exception/server/timeout_exception.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchSoonDisplay extends StatefulWidget {
  const MatchSoonDisplay({super.key});

  @override
  State<MatchSoonDisplay> createState() => _MatchSoonDisplayState();
}

class _MatchSoonDisplayState extends State<MatchSoonDisplay> {
  late Future<List<MatchView>> _future;

  @override
  void initState() {
    super.initState();
    _future = MatchService.instance.getMatchesSoon();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchView>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 36.h),
          child: DetailDefaultFormWidget(
            title: '게임이 곧 시작해요',
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SpaceHeight(12,),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => MatchListWidget(
                match: snapshot.data![index],
                formatType: DateFormatType.REAMIN_TIME,
              ),
            ),
          ),
        );
      },
    );
  }
}