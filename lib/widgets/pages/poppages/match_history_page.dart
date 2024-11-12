
import 'package:groundjp/component/date_range.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/widgets/component/calender.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';

class MatchHistoryWidget extends StatefulWidget {
  const MatchHistoryWidget({super.key});

  @override
  State<MatchHistoryWidget> createState() => _MatchHistoryWidgetState();
}

class _MatchHistoryWidgetState extends State<MatchHistoryWidget> {

  // TODO 경기 취소할 때 같이 반영시켜도 좋을것 같음
  List<MatchView> _items = [];

  void _selectDate(DateTime selectDate, List<MatchView> matches) {
    print('날짜 변경감지 : $selectDate');
    setState(() {
      _items = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경기내역'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              CalenderWidget(
                onChanged: _selectDate,
                monthRange: MonthRange(
                  min: DateTime(2024, 6),
                  max: DateTime(2024, 10),
                ),
              ),
              const SizedBox(height: 16,),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16,);
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return MatchListWidget(match: _items[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
