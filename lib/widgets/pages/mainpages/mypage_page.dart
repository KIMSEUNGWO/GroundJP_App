
import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/user/user_profile.dart';
import 'package:groundjp/notifier/coupon_notifier.dart';
import 'package:groundjp/notifier/favorite_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/component/user_profile_wiget.dart';
import 'package:groundjp/widgets/pages/poppages/user/cash_charge_page.dart';
import 'package:groundjp/widgets/pages/poppages/user/cash_receipt_page.dart';
import 'package:groundjp/widgets/pages/poppages/coupon_list_page.dart';
import 'package:groundjp/widgets/pages/poppages/match_history_page.dart';
import 'package:groundjp/widgets/pages/poppages/user/profile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:groundjp/widgets/pages/poppages/settings/settings_page.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPageWidget extends ConsumerStatefulWidget{

  final Function({required int index, bool loginRequire}) onChangePage;
  const MyPageWidget({super.key, required this.onChangePage});

  @override
  ConsumerState<MyPageWidget> createState() => _MyPageWidgetState();
}

class _MyPageWidgetState extends ConsumerState<MyPageWidget> {

  bool _ensureOnceBuild = false;

  @override
  Widget build(BuildContext context) {
    UserProfile? profile = ref.watch(loginProvider);
    int favoriteCount = ref.watch(favoriteNotifier).length;
    int couponCount = ref.watch(couponNotifier).length;
    if (profile == null) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_ensureOnceBuild) return;
        setState(() => _ensureOnceBuild = true);
        widget.onChangePage(index: 0, loginRequire: true);
      });
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingsWidget();
              },));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: SvgIcon.asset(sIcon: SIcon.settings, style: SvgIconStyle(
                width: 25, height: 25
              )),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              profile == null
              ? CustomContainer(
                child: Center(
                  child: Text('로그인이 필요합니다',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    ),
                  ),
                ),
              )
              : Column(
                children: [
                  // 유저 정보

                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const ProfileEditPage();
                                }, fullscreenDialog: true));
                              },
                              child: Stack(
                                children: [
                                  UserProfileWidget(
                                    diameter: 60,
                                    image: profile.image,
                                  ),
                                  Positioned(
                                    bottom: 0, right: 0,
                                    child: SvgIcon.asset(sIcon: SIcon.pen,),
                                  ),
                                ]
                              ),
                            ),
                            const SpaceWidth(15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.nickname,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                                  ),
                                ),
                                const SpaceHeight(4),
                                Row(
                                  children: [
                                    Text(DateFormat('yyyy-MM-dd').format(profile.birth),
                                      style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                        color: Theme.of(context).colorScheme.secondary
                                      ),
                                    ),
                                    const SpaceWidth(4,),
                                    profile.sex.icon,
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        const SpaceHeight(20,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double containerWidth = constraints.maxWidth / 3;
                              return Row(
                                children: [
                                  SizedBox(
                                    width: containerWidth,
                                    child: Column(
                                      children: [
                                        Text('$favoriteCount',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const SpaceHeight(4,),
                                        const Text('즐겨찾기',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: containerWidth,
                                    child: Column(
                                      children: [
                                        Text('5',
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const SpaceHeight(4,),
                                        const Text('어떤무언가',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: containerWidth,
                                    child: Column(
                                      children: [
                                        Text('$couponCount',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        const SpaceHeight(4,),
                                        const Text('쿠폰',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(15,),
                  // 캐시
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('잔액',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                              ),
                            ),
                            Expanded(
                              child: Text(AccountFormatter.format(profile.cash),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const CashChargeWidget();
                                },));
                              },
                              child: Text('충전',
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                ),
                              ),
                            ),
                            const SpaceWidth(15,),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const CashReceiptWidget();
                                },));
                              },
                              child: Text('내역',
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpaceHeight(15,),

              CustomContainer(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
                backgroundColor: const Color(0xFF6663E8),
                child: Text('함께하고 싶은 친구에게 공유해보세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                  ),
                ),
              ),
              const SpaceHeight(15,),

              CustomContainer(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                child: Column(
                  children: [
                    _Menu(
                      icon: SvgIcon.asset(sIcon: SIcon.clipboard,
                        style: SvgIconStyle(
                          width: 20, height: 20, color: Theme.of(context).colorScheme.primary
                        )
                      ),
                      title: '경기내역',
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const MatchHistoryWidget();
                        },));
                      },
                    ),
                    const SpaceHeight(10,),
                    _Menu(
                      icon: SvgIcon.asset(sIcon: SIcon.coupon),
                      title: '쿠폰',
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const CouponListWidget();
                        },));
                      },
                    ),
                    const SpaceHeight(10,),
                    _Menu(
                      icon: Icon(Icons.logout_outlined, size: 20.sp,),
                      title: '로그아웃',
                      onPressed: (){
                        Alert.of(context).confirm(
                          message: '로그아웃 하시겠습니까?',
                          btnMessage: '로그아웃',
                          onPressed: () {
                            ref.read(loginProvider.notifier).logout(ref);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SpaceHeight(15,),
            ],
          ),
        ),
      ),
    );
  }

}

class _Menu extends StatelessWidget {

  final Widget icon;
  final String title;
  final Function() onPressed;

  const _Menu({required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 30,
            child: icon,
          ),
          const SpaceWidth(10,),
          Expanded(
            child: Text(title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 12,
          )

        ],
      ),
    );
  }
}

