

import 'package:flutter/material.dart';

class DateTimeHelper {


  double calculateHeight(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // (width - 전체 padding - 내부 padding) / 요일 수
    double width = (size.width - 40 - 20) / 7;
    return width * 7;
  }

  static int monthCount(DateTime date) {
    return date.year * 12 + date.month;
  }

  DateTime safeMoveDate(DateTime before, DateTime after) {
    // 8월 31일 -> 9월 30일로 마지막 달로 안전하게 이동하도록 하는 메소드

    // 이동하려는 월의 일수를 계산
    int beforeDaysInMonth = DateTime(before.year, before.month + 1, 0).day;
    int afterDaysInMonth = DateTime(after.year, after.month + 1, 0).day;

    // 이동하려는 월의 일수보다 초과한다면 (8월 31일 선택 후 다음 버튼을 누르면 9월 30일로 이동하기 위함)
    if (beforeDaysInMonth < afterDaysInMonth) {
      return DateTime(after.year, after.month, beforeDaysInMonth);
    }
    return DateTime(after.year, after.month, before.day);
  }

  List<DateTime> generate(DateTime date) {
    List<DateTime> result = [];

    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);


    int startWeekday = firstDayOfMonth.weekday % 7; // 1: 월요일, 7: 일요일
    // 이전 달의 마지막 날짜들 추가
    if (startWeekday > 0) {
      for (int i = startWeekday; i > 0; i--) {
        result.add(firstDayOfMonth.add(Duration(days: -1 * i)));
      }
    }

    int daysInMonth = DateTime(date.year, date.month + 1, 0).day; // 해당 월의 일수
    for (int i=0;i<daysInMonth;i++) {
      result.add(firstDayOfMonth.add(Duration(days: i)));
    }

    // 다음 달의 첫 날짜들 추가
    int remainingDays = 7 - result.length % 7;
    if (remainingDays < 7) {
      for (int i = 1; i <= remainingDays; i++) {
        result.add(firstDayOfMonth.add(Duration(days: daysInMonth + i - 1)));
      }
    }

    return result;

  }

}