
import 'package:groundjp/component/calendar_date_helper.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/page_view.dart';

class CalendarController {

  final PageController pageController;
  final MonthRange range;

  bool prevDisabled = false;
  bool nextDisabled = false;

  final Duration _duration = const Duration(milliseconds: 500);
  final Cubic curves = Curves.easeInOut;

  CalendarController({required this.range}):
    pageController = PageController(
      initialPage: range.initPage,
      keepPage: true,
    );


  void pageChange(int page) {
    prevDisabled = 0 >= page;
    nextDisabled = range.maxPage - 1 <= page;
  }

  bool hasRange(DateTime date) {
    int monthCount = DateTimeHelper.monthCount(date);
    return !(DateTimeHelper.monthCount(range.min) > monthCount || DateTimeHelper.monthCount(range.max) < monthCount);
  }

  void previousPage() {
    if (prevDisabled) return;
    pageController.previousPage(duration: _duration, curve: curves);
  }
  void nextPage() {
    if (nextDisabled) return;
    pageController.nextPage(duration: _duration, curve: curves);
  }

  Future<void> selectDate(BuildContext context, {required Function() onPressed}) async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true, // showCupertinoDialog 영역 외에 눌렀을 때 닫게 해줌
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment
              .bottomCenter, //특정 위젯이 어디에 정렬을 해야되는지 모르면 height값줘도 최대한에 사이즈를 먹음
          child: Container(
            color: Colors.white,
            height: 300,
            child: Column(
              children: [
                CupertinoButton(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('완료',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.monthYear, //CupertinoDatePickerMode에서 일시, 시간 등 고름
                    initialDateTime: DateTime.now(),

                    onDateTimeChanged: (DateTime date) {
                      print('날짜선택 : $date');
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



}

class MonthRange {

  final DateTime min;
  final DateTime max;
  final int initPage;
  final int maxPage;

  MonthRange({DateTime? min, DateTime? max}):
    min = min ?? DateTime(1900, 1, 1),
    max = max ?? DateTime(2999, 12, 1),
    initPage = DateTimeHelper.monthCount(DateTime.now()) - DateTimeHelper.monthCount(min ?? DateTime(1900, 1, 1)),
    maxPage = DateTimeHelper.monthCount(DateTime.now()) - DateTimeHelper.monthCount(min ?? DateTime(1900, 1, 1))
        + DateTimeHelper.monthCount(max ?? DateTime(2999, 12, 1)) - DateTimeHelper.monthCount(DateTime.now())
        + 1;


}
