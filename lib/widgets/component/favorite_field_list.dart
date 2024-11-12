
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/favorite_icon_button.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/field_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteFieldListWidget extends StatelessWidget {

  final FieldSimp _fieldSimp;
  final bool readOnly;

  const FavoriteFieldListWidget({super.key, required FieldSimp fieldSimp, this.readOnly = false}): _fieldSimp = fieldSimp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FieldDetailWidget(fieldId: _fieldSimp.fieldId);
        },));
      },
      child: CustomContainer(
        padding: EdgeInsets.only(left: 15.w, right: 25.w, top: 10.h, bottom: 10.h,),
        margin: EdgeInsets.only(right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(_fieldSimp.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                  ),
                ),
                const SpaceWidth(10,),
                FavoriteIconButtonWidget(
                  fieldSimp: _fieldSimp,
                  size: 15.sp,
                  disabled: true,
                  readOnly: readOnly,
                ),
              ],
            ),
            const SpaceHeight( 4,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_fieldSimp.region.ko,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                const SpaceWidth(5),
                Text(_fieldSimp.address,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    decoration: TextDecoration.underline
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
