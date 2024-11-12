
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/component/calendar_date_helper.dart';
import 'package:groundjp/component/date_range.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderWidget extends StatefulWidget {
  final Function(DateTime, List<MatchView>) onChanged;
  final MonthRange monthRange;

  CalenderWidget({super.key, MonthRange? monthRange, required this.onChanged}):
    monthRange = monthRange ?? MonthRange();

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {

  late CalendarController _calendarController;
  late DateTime _today;
  late DateTime _selectDate;
  late DateTime _currentMonth;
  final DateTimeHelper calendarHelper = DateTimeHelper();
  late int _previousPage;

  void _preDate() {
    _calendarController.previousPage();
  }
  void _nextDate() {
    _calendarController.nextPage();
  }

  void _select(DateTime date, List<MatchView> matches) {
    if (!_calendarController.hasRange(date)) return;
    setState(() {
      _selectDate = date;
    });
    int currentMonthCount = DateTimeHelper.monthCount(_currentMonth);
    int nextMonthCount = DateTimeHelper.monthCount(date);
    if (currentMonthCount > nextMonthCount) {
      _preDate();
    } else if (currentMonthCount < nextMonthCount) {
      _nextDate();
    }
    widget.onChanged(date, matches);
  }

  void _onPageChanged(int page) {
    _calendarController.pageChange(page);

    setState(() {
      _currentMonth = _onChange(page);
      _previousPage = page;
    });
  }

  // Calendar 에 표시할 DateTime 를 page 로 조회 하는 메소드
  DateTime _onChange(int page) {
    if (_previousPage < page) {
      return DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    } else if (_previousPage > page) {
      return DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    }
    return _currentMonth;
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _currentMonth = DateTime(now.year, now.month, 1);
    _selectDate = DateTime(now.year, now.month, now.day);
    _calendarController = CalendarController(
      range: widget.monthRange,
    );
    _previousPage = _calendarController.pageController.initialPage;
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                },
                child: Text(DateFormat('yyyy년 MM월').format(_currentMonth),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              const SpaceWidth(15,),
              Row(
                children: [
                  GestureDetector(
                    onTap: _preDate,
                    child: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 15,
                      color: _calendarController.prevDisabled
                        ? const Color(0xFF999999)
                        : const Color(0xFF292929),
                    ),
                  ),
                  const SpaceWidth(15,),
                  GestureDetector(
                    onTap: _nextDate,
                    child: Icon(Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: _calendarController.nextDisabled
                        ? const Color(0xFF999999)
                        : const Color(0xFF292929),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SpaceHeight(15),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: calendarHelper.calculateHeight(context)
            ),
            child: PageView.builder(
              controller: _calendarController.pageController,
              onPageChanged: _onPageChanged,
              itemCount: _calendarController.range.maxPage,
              itemBuilder: (context, index) {
                return _Calendar(
                  currentMonth: _onChange(index),
                  today: _today,
                  selectDate: _selectDate,
                  select: _select,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Calendar extends StatefulWidget {

  final DateTime today;
  final DateTime currentMonth;
  final DateTime selectDate;
  final Function(DateTime date, List<MatchView> matches) select;

  const _Calendar({required this.today, required this.currentMonth, required this.selectDate, required this.select});

  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> with AutomaticKeepAliveClientMixin {
  final List<String> _weeks = ['일', '월', '화', '수', '목', '금', '토'];
  final DateTimeHelper calendarHelper = DateTimeHelper();

  late final Map<int, List<MatchView>> _exists;
  bool _existLoad = true;

  _fetchExistsHistory() async {
    _exists = await UserService.instance.getHistory(widget.currentMonth);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          _existLoad = false;
        });
      }
    },);

    if (widget.selectDate == widget.today) {
      widget.select(widget.today, _exists[widget.today.day] ?? []);
    }
  }

  @override
  void initState() {
    print('_CalendarState.initState , date : ${widget.currentMonth}');
    _fetchExistsHistory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<DateTime> calendar = calendarHelper.generate(widget.currentMonth);
    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 한 줄에 7개의 항목(요일 수)
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            return Center(
              child: Text(_weeks[index],
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    fontWeight: FontWeight.w600
                ),
              ),
            );
          },
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 한 줄에 7개의 항목(요일 수)
          ),
          itemCount: calendar.length,
          itemBuilder: (context, index) {

            DateTime date = calendar[index];
            bool isToday = widget.today.compareTo(date) == 0;
            bool isSelectDay = widget.selectDate.compareTo(date) == 0;

            return GestureDetector(
              onTap: () {
                List<MatchView> matches = [];
                if (date.year == widget.currentMonth.year && date.month == widget.currentMonth.month) {
                  matches = _exists[date.day] ?? [];
                }
                widget.select(date, matches);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isSelectDay
                        ? Theme.of(context).colorScheme.onPrimary
                        : null
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${date.day}',
                        style: TextStyle(
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            fontWeight: FontWeight.w600,
                            color: (widget.currentMonth.year != date.year || widget.currentMonth.month != date.month) ? const Color(0xFF797979)
                                : isSelectDay ? Colors.white
                                : date.weekday == 7 ? const Color(0xFFE30000)
                                : const Color(0xFF292929)
                        ),
                      ),

                      _existLoad
                        ? const SizedBox()
                        : (date.month == widget.currentMonth.month && _exists.containsKey(date.day))
                          ? Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).colorScheme.onSecondary
                            ),
                          )
                          : const SizedBox(),
                      if (isToday)
                        Text('Today',
                          style: TextStyle(
                              fontStyle: Theme.of(context).textTheme.bodySmall!.fontStyle,
                              color: isSelectDay ? Colors.white
                                  : null
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}


