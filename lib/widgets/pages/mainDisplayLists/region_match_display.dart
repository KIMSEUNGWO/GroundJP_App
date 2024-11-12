
import 'package:groundjp/api/service/match_service.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/search_condition.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegionMatchDisplay extends ConsumerStatefulWidget {
  const RegionMatchDisplay({super.key});

  @override
  ConsumerState<RegionMatchDisplay> createState() => _RegionMatchDisplayState();
}

class _RegionMatchDisplayState extends ConsumerState<RegionMatchDisplay> {

  late Region? _region;
  bool _loading = false;
  List<MatchView> result = [];

  void _changeRegion(Region region) {
    ref.read(regionProvider.notifier).setRegion(context, region);
  }
  void _fetch(Region region) async {
    if (_loading) return;
    print('_RegionMatchDisplayState._fetch');
    List<MatchView>? data = await MatchService.instance.buffer(context, (p0) => p0.search(SearchCondition(date: DateTime.now(), sexType: null, region: region)),);
    setState(() {
      result = data ?? [];
      _loading = false;
      _region = region;
    });
  }

  @override
  void initState() {
    _region = ref.read(regionProvider.notifier).get();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Region? region = ref.watch(regionProvider);
    if (region == null) {
      return const SizedBox();
    } else if (region != _region) {
      _fetch(region);
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              children: [
                Text('오늘 ',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RegionSelectWidget(onPressed: _changeRegion);
                    },));
                  },
                  child: Text(region.ko,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(' 일정이에요.',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),

          const SpaceHeight(10),

          (result.isEmpty)
          ? const CustomContainer(
            height: 75,
            child: Center(
              child: Text('오늘은 더 이상 경기가 없어요.'),
            ),
          )
          : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SpaceHeight(12,),
            itemCount: result.length,
            itemBuilder: (context, index) => MatchListWidget(
              match: result[index],
              formatType: DateFormatType.TIME,
            ),
          )

        ],
      ),
    );
  }
}
