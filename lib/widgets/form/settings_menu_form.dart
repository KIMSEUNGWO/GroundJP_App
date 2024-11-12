
import 'package:flutter/material.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/space_custom.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsMenuFormWidget extends StatelessWidget {

  final String title;
  final List<SettingsMenuWidget> menus;
  const SettingsMenuFormWidget({super.key, required this.title, required this.menus});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SpaceHeight(10),
          Column(
            children: menus,
          ),
        ],
      ),
    );
  }
}

class SettingsMenuWidget extends StatefulWidget {

  final String menuTitle;
  final Widget action;
  final VoidCallback? onPressed;

  const SettingsMenuWidget({super.key, required this.menuTitle, required this.action, this.onPressed});

  @override
  State<SettingsMenuWidget> createState() => _SettingsMenuWidgetState();
}

class _SettingsMenuWidgetState extends State<SettingsMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        splashColor: Colors.transparent, // 기본 InkWell 효과 삭제
        highlightColor: Colors.grey.withOpacity(0.2), // 누르고있을때 색상
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 25.w, right: 15.w),
          child: Row(
            children: [
              Expanded(
                child: Text(widget.menuTitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              widget.action,
            ],
          ),
        ),
      ),
    );
  }
}


class ListSeparatorBuilder {
  
  final List<Widget> items;
  final Widget separator;

  ListSeparatorBuilder({required this.items, required this.separator});

  List<Widget> build() {
    return List<Widget>.from(items.expand((item) sync* {
      yield item;
      if (item != items.last) yield separator;
    },));
  }
  
}