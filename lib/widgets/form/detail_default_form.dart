
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:groundjp/widgets/component/space_custom.dart';

class DetailDefaultFormWidget extends StatelessWidget {

  final String title;
  final EdgeInsets? titlePadding;
  final Widget child;
  final TextStyle? textStyle;

  const DetailDefaultFormWidget({super.key, required this.title, required this.child, this.titlePadding, this.textStyle});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: titlePadding ?? EdgeInsets.only(left: 5.w),
          child: Text(title,
            style: textStyle ?? TextStyle(
              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
        ),

        const SpaceHeight(10,),

        child
      ],
    );
  }
}
