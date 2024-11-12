
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/service/match_service.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/search_condition.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/component/search_data.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectMatchSheetWidget extends ConsumerStatefulWidget {

  final ScrollController controller;
  final Function(MatchView match) onPressed;
  const SelectMatchSheetWidget({super.key, required this.controller, required this.onPressed});

  @override
  createState() => _SelectMatchSheetWidgetState();
}

class _SelectMatchSheetWidgetState extends ConsumerState<SelectMatchSheetWidget> {

  int _currentDateIndex = 0;
  bool _loading = true;

  late List<MatchView> _items = [];
  late SearchCondition _condition;

  _selectRegion(Region region) {
    if (_condition.region == region) return;
    _search(
        SearchCondition(
          date: _condition.date,
          sexType: _condition.sexType,
          region: region,
        )
    );
  }
  _search(SearchCondition condition) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        setState(() {
          _condition = condition;
        });
        List<MatchView>? response = await MatchService.instance.buffer(context, (p0) => p0.search(_condition),);
        setState(() {
          _items = response ?? [];
          _loading = false;
        });
      }
    },);
  }

  _onPressed(MatchView match) {
    widget.onPressed(match);
    Navigator.pop(context);
  }

  @override
  void initState() {
    final now = DateTime.now();
    _condition = SearchCondition(
      date: DateTime(now.year, now.month, now.day),
      sexType: null,
      region: ref.read(regionProvider.notifier).get(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return RegionSelectWidget(
                  onPressed: _selectRegion,
                );
              },));
            },
            child: Container(
              padding: EdgeInsets.only(top: 20.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((_condition.region ?? Region.ALL).getLocaleName(const Locale('ko', 'KR')),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
            ),
          ),
          SearchData(
            search: _search,
            selectedDateIndex: _currentDateIndex,
            borderRadius: BorderRadius.circular(0),
            region: _condition.region,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _items.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text('매치가 없어요',
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SpaceHeight(16,),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(top: 32.h),
                        child: MatchListWidget(
                          match: _items[index],
                          onPressed: _onPressed,
                        ),
                      );
                    } else if (index == _items.length - 1) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 32.h),
                        child: MatchListWidget(
                          match: _items[index],
                          onPressed: _onPressed
                        ),
                      );
                    }
                    return MatchListWidget(
                      match: _items[index],
                      onPressed: _onPressed
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
