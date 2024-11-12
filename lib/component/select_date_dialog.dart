

import 'package:groundjp/component/date_range.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectDateDialog {

  SelectDateDialog.privateConstructor();

  static _SelectDateDialogBuilder of(BuildContext context) {
    return _SelectDateDialogBuilder(context);
  }
}

class _SelectDateDialogBuilder {

  final BuildContext _context;
  DateTime? _date;

  _SelectDateDialogBuilder(this._context);

  void selectDate({
    required CupertinoDatePickerMode mode,
    required Function(DateTime?) onPressed,
    DateTime? initialDateTime,
  }) {

    DateTime now = DateTime.now();
    DateTime max = DateTime(now.year - 17, now.month, now.day);
    if (initialDateTime == null) {
      initialDateTime = max;
    } else if (max.isBefore(initialDateTime)) {
      initialDateTime = max;
    }
    _date = initialDateTime;

    showCupertinoDialog(
      context: _context,
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
                    onPressed(_date);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: mode, //CupertinoDatePickerMode에서 일시, 시간 등 고름
                    initialDateTime: _date,
                    maximumDate: max,
                    minimumDate: DateTime(1950, 1, 1),
                    maximumYear: max.year,
                    dateOrder: DatePickerDateOrder.ymd,
                    onDateTimeChanged: (DateTime date) {
                      _date = date;
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