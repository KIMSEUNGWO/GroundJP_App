
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScrollRefresh extends StatelessWidget {

  final Function onRefresh;

  const CustomScrollRefresh({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 150.0.h,
      refreshIndicatorExtent: 100.0.h,
      onRefresh: () async {
        // 위로 새로고침
        await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
        onRefresh();
      },
    );
  }
}
