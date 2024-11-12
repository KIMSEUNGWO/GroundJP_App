
import 'package:flutter/material.dart';
import 'package:groundjp/domain/match/statistics.dart';
import 'package:groundjp/widgets/component/chart_donut_painter_widget.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:image_cropper/image_cropper.dart';

class MatchStatisticsFormWidget extends StatelessWidget {

  final Statistics? statistics;
  const MatchStatisticsFormWidget({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    if (statistics == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DetailDefaultFormWidget(
        title: '매치데이터',
        child: Row(
          children: [
            Expanded(
              child: CustomContainer(
                child: Center(
                  child: ChartDonutPainterWidget(
                    title: '성별',
                    diameter: 150,
                    data: statistics?.sexStatistics?.entries.map((entry) => ChartData(title: entry.key.ko, value: entry.value, color: entry.key.color)).toList() ?? []
                  ),
                ),
              ),
            ),
            const SpaceWidth(10),
            Expanded(
              child: CustomContainer(
                child: Center(
                  child: ChartDonutPainterWidget(
                    title: '등급',
                    diameter: 150,
                    data: [
                      ChartData(title: '루키', value: 14, color: Colors.brown),
                      ChartData(title: '스타터', value: 4, color: Colors.grey),
                      ChartData(title: '비기너', value: 4, color: Colors.amberAccent),
                      ChartData(title: '아마추어', value: 4, color: Colors.cyan),
                      ChartData(title: '세미프로', value: 4, color: Colors.deepPurple),
                      ChartData(title: '프로', value: 4, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
