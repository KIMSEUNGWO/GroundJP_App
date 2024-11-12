
import 'package:flutter/cupertino.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/enums/payment.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/register_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginWidget extends ConsumerStatefulWidget{
  const LoginWidget({super.key});

  @override
  createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {

  bool _loading = false;

  _setLoading(bool data) {
    setState(() {
      _loading = data;
    });
  }

  _onTryLogin(BuildContext context, WidgetRef ref, SocialProvider provider) async {
    _setLoading(true);
    final result = await ref.read(loginProvider.notifier).login(context, ref, provider);
    print('result : ${result.resultCode}');

    if (result.resultCode == ResultCode.OK) {
      print('로그인 성공');
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else  if (result.resultCode == ResultCode.REGISTER) {
      print('회원가입 시도');
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterWidget(social: result.data,)));
      }
    } else {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 170.h, bottom: MediaQuery.of(context).padding.bottom + 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: SvgIcon.asset(
                sIcon: SIcon.logo,
                style: SvgIconStyle(
                  width: 300
                )
              )),

              Column(
                children: [
                  _SocialBtn(
                    title: '라인으로 계속하기',
                    fontColor: Colors.white,
                    color: Payment.LINE.backgroundColor,
                    sIcon: SIcon.lineLogo,
                    onPressed: () {
                      _onTryLogin(context, ref, SocialProvider.LINE);
                    },
                  ),
                  const SpaceHeight(12,),
                  _SocialBtn(
                    title: '카카오로 계속하기',
                    fontColor: const Color(0xFF181602),
                    color: Payment.KAKAO.backgroundColor,
                    sIcon: SIcon.kakaoLogo,
                    onPressed: () {
                      _onTryLogin(context, ref, SocialProvider.KAKAO);
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 40.h, bottom: 25.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFF666666).withOpacity(0.5)
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: const Text('다른 계정으로 계속하기'),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFF666666).withOpacity(0.5)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SmallSocialBtn(
                    icon: Icon(Icons.apple, color: Colors.white, size: 25.sp,),
                    color: const Color(0xFF434343),
                    onPressed: () {
                      _onTryLogin(context, ref, SocialProvider.APPLE);
                    },
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
        if (_loading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: const CupertinoActivityIndicator(),
            ),
          ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {

  final String title;
  final Color color;
  final Color fontColor;
  final SIcon sIcon;
  final Function() onPressed;

  const _SocialBtn({required this.title, required this.color, required this.fontColor, required this.sIcon, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.sp,
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Row(
          children: [
            SvgIcon.asset(sIcon: sIcon, style: SvgIconStyle(
              width: 20, height: 20, color: fontColor
            )),
            Expanded(
              child: Center(
                child: Text(title,
                  style: TextStyle(
                    color: fontColor,
                    fontWeight: FontWeight.w700,
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SmallSocialBtn extends StatelessWidget {
  
  final Icon icon;
  final Color color;
  final Function() onPressed;

  const _SmallSocialBtn({required this.icon, required this.color, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50.sp, height: 50.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}


