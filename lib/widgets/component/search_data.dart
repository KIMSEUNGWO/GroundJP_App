
import 'package:groundjp/component/constant.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/search_condition.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SearchData extends ConsumerStatefulWidget {
  final Function(SearchCondition condition) search;
  final BorderRadius? borderRadius;
  final int selectedDateIndex;
  final Region? region;

  const SearchData({super.key, required this.search, required this.selectedDateIndex, this.borderRadius, this.region});

  @override
  ConsumerState<SearchData> createState() => _SearchDataState();
}

class _SearchDataState extends ConsumerState<SearchData> {

  late List<DateTime> dateList;
  late int _selectedDateIndex;
  SexType? _selectedSexType;

  _changeDate(int index) {
    if (_selectedDateIndex == index) return;
    setState(() => _selectedDateIndex = index);
    _search();
  }

  _search() async {
    SearchCondition condition = SearchCondition(
      date: dateList[_selectedDateIndex],
      sexType: _selectedSexType,
      region: widget.region ?? ref.read(regionProvider.notifier).get(),
    );
    widget.search(condition);
  }
  _changeSex(SexType? sexType) {
    if (_selectedSexType == sexType) return;
    setState(() => _selectedSexType = sexType);
    _search();
  }
  double? _containerHeight = 104;
  bool _hasOpen = false;
  _containerExpand() {
    setState(() {
      if (_containerHeight == 104) {
        _containerHeight = 204;
        _hasOpen = true;
      } else {
        _containerHeight = 104;
        _hasOpen = false;
      }
    });
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    // 오늘 기준은 현재 시간까지 고려
    DateTime today = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    // 다음날부터는 시간 고려 없이 0시 0분 기준
    DateTime notToday = DateTime(now.year, now.month, now.day);
    dateList = List.generate(Constant.MAX_DATE_LENGTH, (index) {
      if (index == 0) return today;
      return notToday.add(Duration(days: index));
    });
    _selectedDateIndex = widget.selectedDateIndex;
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: _containerHeight?.h,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 4,
          )
        ],
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
            child: Wrap(
              runSpacing: 30.h,
              children: [
                _SelectDate(selectedDateIndex: _selectedDateIndex, changeDate: _changeDate, dateList: dateList),
                _SelectSex(changeSex: _changeSex, selectedSexType: _selectedSexType,),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0, right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: _containerExpand,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                  decoration: const BoxDecoration(),
                  child: _hasOpen
                    ? SvgIcon.asset(sIcon: SIcon.moreClose)
                    : SvgIcon.asset(sIcon: SIcon.more),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}

class _SelectDate extends StatelessWidget {
  
  final int selectedDateIndex;
  final Function(int index) changeDate;
  final List<DateTime> dateList;
  
  const _SelectDate({required this.selectedDateIndex, required this.changeDate, required this.dateList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66.h,
      child: LayoutBuilder(
          builder: (context, constraints) {
            double totalWidth = constraints.maxWidth; // 전체 너비
            double containerWidth = totalWidth / 7; // 각 Container의 너비

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dateList.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    changeDate(i);
                  },
                  child: Container(
                    width: containerWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedDateIndex == i ? Theme.of(context).colorScheme.onTertiary : Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('E', 'ko_KR').format(dateList[i]),
                          style: TextStyle(
                              color: dateList[i].weekday == 7 ? Colors.red
                              : selectedDateIndex == i
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                              fontWeight:
                              selectedDateIndex == i
                                ? FontWeight.w600
                                : FontWeight.w400,
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                          ),
                        ),
                        const SpaceHeight(8),
                        Text(i == 0 || dateList[i - 1].month != dateList[i].month
                            ? '${dateList[i].month}.${dateList[i].day}'
                            : '${dateList[i].day}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: selectedDateIndex == i
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                          ),
                        )
                      ],
                    ),
                  ),
                );

              },
            );
          }
      ),
    );
  }
}

class _SelectSex extends StatelessWidget {

  final SexType? selectedSexType;
  final Function(SexType?) changeSex;

  _SelectSex({required this.selectedSexType, required this.changeSex});

  final List<String> titles = ['전체', '남자', '여자'];
  final List<SexType?> types = [null, SexType.MALE, SexType.FEMALE];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66.h,
      child: LayoutBuilder(
          builder: (context, constraints) {
            double totalWidth = constraints.maxWidth; // 전체 너비
            double containerWidth = totalWidth / 7; // 각 Container의 너비

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    changeSex(types[index]);
                  },
                  child: Container(
                    width: containerWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selectedSexType == types[index] ? Theme.of(context).colorScheme.onTertiary : Colors.white,
                    ),
                    child: Center(
                      child: Text(titles[index],
                        style: TextStyle(
                            color: selectedSexType == types[index]
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            fontWeight: selectedSexType == types[index]
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
      ),
    );
  }
}

