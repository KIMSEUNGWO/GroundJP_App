

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/bottom_bar_widget.dart';
import 'package:groundjp/widgets/pages/mainpages/community_page.dart';
import 'package:groundjp/widgets/pages/mainpages/home_page.dart';
import 'package:groundjp/widgets/pages/mainpages/match_list_page.dart';
import 'package:groundjp/widgets/pages/mainpages/mypage_page.dart';
import 'package:groundjp/widgets/pages/poppages/user/login_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


class App extends ConsumerStatefulWidget {

  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {

  late PageController _pageController;
  bool _dataLoading = true;
  int _currentIndex = 0;

  onChangePage({required int index, bool loginRequire = false}) {
    setState(() { _currentIndex = index;});
    _pageController.jumpToPage(index);

    if (loginRequire) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LoginWidget();
      }, fullscreenDialog: true));
    }
  }

  initData() async {
    await ref.read(loginProvider.notifier).init(ref);
    setState(() {
      _dataLoading = false;
    });
  }

  @override
  void initState() {
    _pageController = PageController();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dataLoading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: const Center(child: CupertinoActivityIndicator(),),
      );
    }
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeWidget(),
          const CommunityWidget(),
          const MatchListPageWidget(),
          MyPageWidget(onChangePage: onChangePage),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        height: 57,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomIcon(
              sIcon: SIcon.home,
              callback: () => onChangePage(index: 0),
              isPressed: _currentIndex == 0,
            ),
            BottomIcon(
              sIcon: SIcon.speechBubble,
              callback: () => onChangePage(index: 1),
              isPressed: _currentIndex == 1,
            ),
            BottomIcon(
              sIcon: SIcon.clipboard,
              callback: () => onChangePage(index: 2),
              isPressed: _currentIndex == 2,
            ),
            BottomIcon(
              sIcon: SIcon.person,
              callback: () {
                bool hasLogin = ref.read(loginProvider.notifier).has();
                if (hasLogin) {
                  onChangePage(index: 3);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return const LoginWidget();
                  },fullscreenDialog: true));
                }
              },
              isPressed: _currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {

  final SIcon sIcon;
  final GestureTapCallback callback;
  final bool isPressed;

  const BottomIcon({super.key, required this.sIcon, required this.callback, required this.isPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
        decoration: const BoxDecoration(),
        child: SvgIcon.asset(
          sIcon: sIcon,
          style: isPressed
            ? SvgIconStyle(color: Theme.of(context).colorScheme.onPrimary,)
            : null
        ),
      ),
    );
  }
}

