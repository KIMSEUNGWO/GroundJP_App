
import 'package:flutter/cupertino.dart';
import 'package:groundjp/api/service/match_service.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/search_condition.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/component/search_data.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MatchListPageWidget extends ConsumerStatefulWidget {
  const MatchListPageWidget({super.key});

  @override
  ConsumerState<MatchListPageWidget> createState() => _MatchListPageWidgetState();
}

class _MatchListPageWidgetState extends ConsumerState<MatchListPageWidget> with AutomaticKeepAliveClientMixin {

  int _currentDateIndex = 0;
  bool _loading = true;
  
  late List<MatchView> _items = [];
  int _pageNumber = 0;
  final int _pageSize = 10;
  bool _hasMoreData = true;


  late SearchCondition _condition;

  _selectRegion(Region region) {
    ref.read(regionProvider.notifier).setRegion(context, region);
    Region? newRegion = ref.read(regionProvider.notifier).get();
    if (_condition.region == newRegion) return;
    _search(
      SearchCondition(
        date: _condition.date,
        sexType: _condition.sexType,
        region: newRegion
      )
    );
  }

  _search(SearchCondition condition) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _loading = true;
      });
      _condition = condition;
      await _fetch();
      setState(() {
        _loading = false;
      });
    },);
  }

  _fetch() async {
    List<MatchView>? response = await MatchService.instance.buffer(context, (p0) => p0.search(_condition),);
    setState(() {
      _items = response ?? [];
    });
  }

  _externalRegionChangeEvent(Region region) async {
    _condition = SearchCondition(
        date: _condition.date,
        sexType: _condition.sexType,
        region: region
    );
    await _fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Region region = ref.watch(regionProvider) ?? Region.ALL;
    if (!_loading && region != _condition.region) {
      _externalRegionChangeEvent(region);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RegionSelectWidget(
                onPressed: _selectRegion,
              );
            },));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(region.getLocaleName(const Locale('ko', 'KR')),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const Icon(Icons.keyboard_arrow_down_rounded)
            ]
          ),
        ),

      ),

      body: Column(
        children: [
          SearchData(
            search: _search,
            selectedDateIndex: _currentDateIndex,
          ),
          (_loading)
          ? const Expanded(child: Center(child: CupertinoActivityIndicator(),)) :
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _items.isEmpty
              ? Center(
               child: Text('매치가 없어요',
                 style: TextStyle(
                   fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
                 ),
               ),
              )
              : ListView.separated(
                  separatorBuilder: (context, index) => const SpaceHeight(16,),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(top: 32.h),
                        child: MatchListWidget(match: _items[index]),
                      );
                    } else if (index == _items.length - 1) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 32.h),
                        child: MatchListWidget(match: _items[index]),
                      );
                    }
                    return MatchListWidget(match: _items[index]);
                  },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

