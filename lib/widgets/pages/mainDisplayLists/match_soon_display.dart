
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

class MatchSoonDisplay extends ConsumerStatefulWidget {
  const MatchSoonDisplay({super.key});

  @override
  ConsumerState<MatchSoonDisplay> createState() => _MatchSoonDisplayState();
}

class _MatchSoonDisplayState extends ConsumerState<MatchSoonDisplay> {

  late List<MatchView> _result = [];

  _fetch() async {
    try {
      List<MatchView> data = await MatchService.instance.getMatchesSoon();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          setState(() {
            _result = data;
          });
        }
      },);
    } on TimeOutException catch (e) {
      if (mounted) {
        Alert.of(context).message(
          message: e.message,
        );
      }
    } on InternalSocketException catch (e) {
      if (mounted) {
        Alert.of(context).message(
          message: e.message,
        );
      }
    } on ServerException catch (e) {
      print('Server Exception : ${e.message}');
    }
  }

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    if (state == null || _result.isEmpty) return const SizedBox();

    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 36.h),
      child: DetailDefaultFormWidget(
        title: '게임이 곧 시작해요',
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SpaceHeight(12,),
          itemCount: _result.length,
          itemBuilder: (context, index) => MatchListWidget(
            match: _result[index],
            formatType: DateFormatType.REAMIN_TIME,
          ),
        ),
      ),
    );
  }
}
