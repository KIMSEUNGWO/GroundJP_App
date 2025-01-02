

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/board_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/datetime_formatter.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/board/board.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/board/board_match_view.dart';
import 'package:groundjp/widgets/component/board/board_user_profile.dart';
import 'package:groundjp/widgets/component/custom_bottom_action_sheet.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:groundjp/widgets/pages/poppages/community_edit_page.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoardDetailWidget extends ConsumerStatefulWidget {
  final int boardId;
  final Function(int boardId)? notExistsEvent;
  const BoardDetailWidget({super.key, required this.boardId, this.notExistsEvent});

  @override
  createState() => _BoardDetailWidgetState();
}

class _BoardDetailWidgetState extends ConsumerState<BoardDetailWidget> {
  
  late Board _board;
  bool _isLoading = true;

  _delete() async {
    ResponseResult result = await BoardService.instance.deleteBoard(boardId: _board.boardId,);

    final code = result.resultCode;


    if (code == ResultCode.OK) {
      Alert.of(context).message(
        message: '삭제되었습니다.',
        onPressed: () {
          if (widget.notExistsEvent != null) {
            widget.notExistsEvent!(_board.boardId);
          }
          Navigator.pop(context);
        },
      );
    } else if (code == ResultCode.BOARD_NOT_EXISTS) {
      Alert.of(context).message(
        message: '존재하지 않는 게시글입니다.',
        onPressed: () {
          if (widget.notExistsEvent != null) {
            widget.notExistsEvent!(_board.boardId);
          }
          Navigator.pop(context);
        },
      );
    } else if (code == ResultCode.UNAUTHRIZED) {
      Alert.of(context).message(
        message: '권한이 없습니다.',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
  }

  _init() async {
    ResponseResult result = await BoardService.instance.getBoardDetail(boardId: widget.boardId);
    
    if (result.resultCode == ResultCode.OK) {
      setState(() {
        _board = Board.fromJson(result.data);
        _isLoading = false;
      });
    } else if (result.resultCode == ResultCode.BOARD_NOT_EXISTS) {
      Alert.of(context).message(
        message: '존재하지 않는 게시글입니다.',
        onPressed: () {
          if (widget.notExistsEvent != null) {
            widget.notExistsEvent!(widget.boardId);
          }
          Navigator.pop(context);
        },
      );
    }
  }
  
  @override
  void initState() {
    _init();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              GestureDetector(
                onTap: _moreTab,
                child: Container(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 15.h, bottom: 15.h),
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: const BoxDecoration(),
                  child: SvgIcon.asset(sIcon: SIcon.more,
                    style: SvgIconStyle(
                      color: Theme.of(context).colorScheme.primary
                    )
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: (_isLoading) ? const SizedBox()
            : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceHeight(26),
                    BoardUserProfileWidget(user: _board.user),
                    const SpaceHeight(16),
                    Text(_board.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SpaceHeight(8),
                    Row(
                      children: [
                        Text((_board.region ?? Region.ALL).getLocaleName(const Locale('ko', 'KR'))),
                        const SpaceWidth(10),
                        Text(DateTimeFormatter.formatDate(_board.createDate),),
                        if (_board.isUpdated)
                          const Text(' (수정됨)'),
                      ],
                    ),
                    const SpaceHeight(26),
                    Text(_board.content,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                    if (_board.match != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: DetailDefaultFormWidget(
                          title: '${DateFormat.MMMd('ko_KR').format(_board.match!.matchDate)} ${DateFormat.H('ko_KR').format(_board.match!.matchDate)}에 경기가 있어요',
                          child: BoardMatchViewWidget(match: _board.match!),
                        ),
                      ),

                    SpaceHeight(MediaQuery.paddingOf(context).bottom + 60.h),
                  ],
                ),
              ),
          ),
        ),

        if (_isLoading)
          const Positioned(
            child: Center(
              child: CupertinoActivityIndicator(radius: 13,),
            ),
          ),
      ],
    );
  }

  _moreTab() {
    List<ActionSheetItem> items = [];

    final user = ref.read(loginProvider.notifier).get();
    if (user?.id == _board.user.userId) {
      items.addAll([
        ActionSheetItem(
          text: const Text('수정하기'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CommunityEditWidget(
                board: _board,
                refresh: _init,
              );
            }, fullscreenDialog: true));
          },
        ),
        ActionSheetItem(
          text: const Text('삭제하기',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Alert.of(context).confirm(
              message: '게시글을 삭제하시겠습니까?',
              btnMessage: '삭제',
              onPressed: _delete,
            );
          },
        ),
      ]);
    }

    CustomBottomActionSheets.instance.showBottomActionSheet(context, items);
  }
}
