import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/service/board_service.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/board/board_simp.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/board/board_widget.dart';
import 'package:groundjp/widgets/component/custom_scroll_refresh.dart';
import 'package:groundjp/widgets/component/pageable_listview.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/community_create_page.dart';
import 'package:groundjp/widgets/pages/poppages/user/login_page.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityWidget extends ConsumerStatefulWidget {
  const CommunityWidget({super.key});

  @override
  createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends ConsumerState<CommunityWidget> with AutomaticKeepAliveClientMixin {

  // 게시글 생성 시, 삭제된 게시글이 존재할 경우 refresh를 위한 globalKey 관리
  GlobalKey<PageableListViewState> _globalKey = GlobalKey<PageableListViewState>();
  late Region _region;

  _selectRegion(Region region) {
    if (_region == region) return;
    setState(() => _region = region);
    _refresh();
  }

  _getNotExistsBoardId(int boardId) {
    _globalKey.currentState?.removeItem((board) {
        return (board as BoardSimp).boardId == boardId;
    },);
  }

  Future<List<BoardSimp>> _fetch(Pageable pageable) async {
    final result = await BoardService.instance.buffer(context, (p0) => p0.getBoardList(region: _region, pageable: pageable),);
    if (result == null) {
      return [];
    } else {
      return result;
    }
  }

  _refresh() {
    setState(() {
      // Increment the refresh key to trigger a full rebuild of PageableListView
      _globalKey = GlobalKey<PageableListViewState>();
    });
  }

  @override
  void initState() {
    _region = ref.read(regionProvider.notifier).get() ?? Region.ALL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RegionSelectWidget(onPressed: _selectRegion,);
            },));
          },
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_region.getLocaleName(const Locale('ko', 'KR')),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const Icon(Icons.keyboard_arrow_down_rounded)
              ]
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    CustomScrollRefresh(
                      onRefresh: _refresh,
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      sliver: PageableListView.sliver(
                        // key: ValueKey(_refreshKey),  // Use the refreshKey to force a rebuild
                        key: _globalKey,
                        pageableSize: 20,
                        separatorBuilder: (context, index) => const SpaceHeight(16),
                        future: _fetch,
                        builder: (boardSimp) => BoardWidget(
                          boardSimp: boardSimp,
                          notExistsEvent: _getNotExistsBoardId
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20, right: 0,
                  child: GestureDetector(
                    onTap: () {
                      bool hasLogin = ref.read(loginProvider.notifier).has();
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return hasLogin ? CommunityCreateWidget(refresh: _refresh) : const LoginWidget();
                      }, fullscreenDialog: true));
                    },
                    child: Container(
                      width: 50.sp, height: 50.sp,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.onSecondary
                      ),
                      child: Center(
                          child: Icon(Icons.add_rounded,
                            color: Colors.white,
                            size: 35.sp,
                          )
                      ),
                    ),
                  ),
                )
              ]
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
