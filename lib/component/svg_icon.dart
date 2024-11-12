import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SvgIcon extends StatelessWidget {

  final Skeleton svgPicture;

  SvgIcon.privateConstructor(SvgPicture svgPicture, {super.key}):
    svgPicture = Skeleton.shade(child: svgPicture);

  static SvgIcon asset({required SIcon sIcon, SvgIconStyle? style,}) {
    return _SvgIconBuilder(sIcon: sIcon).build(style);
  }

  @override
  Widget build(BuildContext context) {
    return svgPicture;
  }

}

class SvgIconStyle {

  double? width;
  double? height;
  Color? color;
  BoxFit? fit;
  BlendMode? blendMode;

  SvgIconStyle({this.width, this.height, this.color, this.fit, this.blendMode});

}

class SIcon {

  final String picture;
  final double width;
  final double height;

  const SIcon({required this.picture, required this.width, required this.height});

  static const SIcon pen = SIcon(picture: 'assets/icons/pen.svg', width: 24, height: 24);

  static const SIcon bell = SIcon(picture: 'assets/icons/bell.svg', width: 28, height: 28);
  static const SIcon bookmark = SIcon(picture: 'assets/icons/bookmark.svg', width: 28, height: 28);
  static const SIcon bookmarkFill = SIcon(picture: 'assets/icons/bookmarkFill.svg', width: 28, height: 28);
  static const SIcon car = SIcon(picture: 'assets/icons/car.svg', width: 15, height: 15);
  static const SIcon check = SIcon(picture: 'assets/icons/check.svg', width: 11, height: 14);
  static const SIcon clipboard = SIcon(picture: 'assets/icons/clipboard.svg', width: 25.59, height: 28);
  static const SIcon coupon = SIcon(picture: 'assets/icons/coupon.svg', width: 24, height: 24);
  static const SIcon gender = SIcon(picture: 'assets/icons/gender.svg', width: 15, height: 15);
  static const SIcon home = SIcon(picture: 'assets/icons/home.svg', width: 25.59, height: 28);

  static const SIcon manager = SIcon(picture: 'assets/icons/manager.svg', width: 15, height: 15);
  static const SIcon megaphone = SIcon(picture: 'assets/icons/megaphone.svg', width: 15, height: 15);
  static const SIcon person = SIcon(picture: 'assets/icons/person.svg', width: 25.59, height: 28);
  static const SIcon personFill = SIcon(picture: 'assets/icons/person_fill.svg', width: 25.59, height: 28);
  static const SIcon search = SIcon(picture: 'assets/icons/search.svg', width: 28, height: 28);
  static const SIcon settings = SIcon(picture: 'assets/icons/settings.svg', width: 20, height: 20);
  static const SIcon shower = SIcon(picture: 'assets/icons/shower.svg', width: 15, height: 15);
  static const SIcon soccer = SIcon(picture: 'assets/icons/soccer.svg', width: 15, height: 15);
  static const SIcon star = SIcon(picture: 'assets/icons/star.svg', width: 15, height: 15);
  static const SIcon success = SIcon(picture: 'assets/icons/success.svg', width: 120, height: 120);
  static const SIcon speechBubble = SIcon(picture: 'assets/icons/speech_bubble.svg', width: 25.59, height: 28);
  static const SIcon toilet = SIcon(picture: 'assets/icons/toilet.svg', width: 15, height: 15);
  static const SIcon more = SIcon(picture: 'assets/icons/more.svg', width: 21, height: 5);
  static const SIcon moreClose = SIcon(picture: 'assets/icons/moreClose.svg', width: 21, height: 5);

  static const SIcon logo = SIcon(picture: 'assets/icons/logo.svg', width: 130, height: 60);
  static const SIcon lineLogo = SIcon(picture: 'assets/icons/line_logo.svg', width: 20, height: 20);
  static const SIcon kakaoLogo = SIcon(picture: 'assets/icons/kakao_logo.svg', width: 20, height: 20);

  static const SIcon kakaoPay = SIcon(picture: 'assets/icons/kakao_pay.svg', width: 60, height: 20);
  static const SIcon linePay = SIcon(picture: 'assets/icons/line_pay.svg', width: 60, height: 20);
  static const SIcon applePay = SIcon(picture: 'assets/icons/apple_pay.svg', width: 60, height: 20);

}

class _SvgIconBuilder {

  final SIcon sIcon;

  _SvgIconBuilder({required this.sIcon});

  SvgIcon build(SvgIconStyle? style) {
    return SvgIcon.privateConstructor(SvgPicture.asset(sIcon.picture,
        width: style?.width?.sp ?? sIcon.width.sp,
        height: style?.height?.sp ?? sIcon.height.sp,
        fit: style?.fit ?? BoxFit.contain,
        colorFilter: style == null || style.color == null ? null : ColorFilter.mode(style.color!, style.blendMode ?? BlendMode.srcIn),
    ));
  }

}