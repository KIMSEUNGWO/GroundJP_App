

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/board_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/constant.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/invalid_data.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/component/select_match_sheet.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityCreateWidget extends ConsumerStatefulWidget {
  final Function() refresh;
  const CommunityCreateWidget({super.key, required this.refresh});

  @override
  createState() => _CommunityCreateWidgetState();
}

class _CommunityCreateWidgetState extends ConsumerState<CommunityCreateWidget> {

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  MatchView? _selectedMatch;
  Region? _selectedRegion;

  String? _errorTitle;
  String? _errorContent;

  bool _isDisabled = true;
  bool isSync = false;

  _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_isDisabled || !_valid()) return;
    if (isSync) return;
    setState(() => isSync = true);

    ResponseResult result = await BoardService.instance.postBoard(
      title: _titleController.text,
      content: _contentController.text,
      matchId: _selectedMatch?.matchId,
      region: _selectedRegion,
    );

    final code = result.resultCode;
    if (code == ResultCode.OK) {
      widget.refresh();
      Alert.of(context).message(
        message: '등록이 완료되었습니다',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else if (code == ResultCode.ACCESS_TOKEN_REQUIRE) {
      Alert.of(context).message(
        message: '로그인이 필요합니다.',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else if (code == ResultCode.INVALID_DATA) {
      _bindingError(InvalidData.fromJson(result.data));
    } else if (code == ResultCode.BAN_WORD_INCLUDE) {
      Alert.of(context).message(
        message: '${result.data} 는 사용할 수 없는 단어입니다.',
        onPressed: () {
          setState(() {
            _isDisabled = false;
          });
        }
      );
    } else {
      print('Result Code : $code');
    }

    setState(() => isSync = false);
  }
  _bindingError(InvalidData data) {
    if (data.field == 'title') {
      _setErrorTitle(data.message);
    }
    if (data.field == 'content') {
      _setErrorContent(data.message);
    }
  }
  bool _valid() {
    bool valid = true;
    String title = _titleController.text;
    if (title.isEmpty) {
      _setErrorTitle('제목을 입력해주세요.');
      valid = false;
    } else if (title.length < 2 || title.length > Constant.BOARD_TITLE_MAX_LENGTH) {
      _setErrorTitle('제목은 2 ~ ${Constant.BOARD_TITLE_MAX_LENGTH}자까지 가능합니다.');
      valid = false;
    }

    String content = _contentController.text;
    if (content.isEmpty) {
      _setErrorContent('내용을 입력해주세요.');
      valid = false;
    } else if (content.length > Constant.BOARD_CONTENT_MAX_LENGTH) {
      _setErrorContent('내용은 ${Constant.BOARD_CONTENT_MAX_LENGTH}까지 가능합니다.');
      valid = false;
    }

    return valid;
  }
  _setErrorTitle(String? message) => setState(() => _errorTitle = message);
  _setErrorContent(String? message) => setState(() => _errorContent = message);

  _titleOnChanged(String title) {
    _setErrorTitle(null);
    _onChanged(title);
  }
  _contentOnChanged(String content) {
    _setErrorContent(null);
    _onChanged(content);
  }

  void _onChanged(String str) {
    setState(() {
      _isDisabled = _titleController.text.isEmpty || _contentController.text.isEmpty;
    });
  }

  _selectMatch(MatchView match) {
    setState(() {
      _selectedMatch = match;
    });
  }
  _selectRegion(Region region) {
    setState(() {
      _selectedRegion = region;
    });
  }
  _bottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF1F3F5),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.8,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return SelectMatchSheetWidget(
              controller: controller,
              onPressed: _selectMatch
            );
          },
        );
      },
    );
  }


  _loginCheck() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (!ref.read(loginProvider.notifier).has()) {
          Alert.of(context).message(
            message: '로그인 후 사용 가능 합니다.',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }
      }
    },);
  }

  @override
  void initState() {
    _loginCheck();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _selectedRegion = ref.read(regionProvider.notifier).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final safeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text('게시글 등록'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close_rounded),
            )
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailDefaultFormWidget(
                  title: '제목',
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                  child: TextField(
                    onChanged: _titleOnChanged,
                    controller: _titleController,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    maxLength: Constant.BOARD_TITLE_MAX_LENGTH,
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: const Color(0xFFF2F4F4),
                      filled: true,
                      errorText: _errorTitle,
                      errorBorder: _inputErrorBorder,
                      enabledBorder: _inputBorder,
                      focusedErrorBorder: _inputBorder,
                      focusedBorder: _inputBorder,
                      hintText: '제목을 입력해주세요.',
                      hintStyle: _hintTextStyle(context),
                    ),
                    cursorColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SpaceHeight(24,),

                DetailDefaultFormWidget(
                  title: '내용',
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                  child: TextField(
                    controller: _contentController,
                    onChanged: _contentOnChanged,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                    ),
                    maxLength: Constant.BOARD_CONTENT_MAX_LENGTH,
                    minLines: 8,
                    maxLines: 20,
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFF2F4F4),
                      filled: true,
                      errorText: _errorContent,
                      errorBorder: _inputErrorBorder,
                      enabledBorder: _inputBorder,
                      focusedErrorBorder: _inputBorder,
                      focusedBorder: _inputBorder,
                      hintText: '내용을 입력해주세요.',
                      hintStyle: _hintTextStyle(context),
                    ),
                    cursorColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SpaceHeight(16,),
                DetailDefaultFormWidget(
                  title: '지역',
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return RegionSelectWidget(
                          onPressed: _selectRegion,
                        );
                      },));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10.w, right: 20.w, top: 10.h, bottom: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 20.sp,
                          ),
                          const SizedBox(width: 5,),
                          Text((_selectedRegion ?? Region.ALL).getLocaleName(const Locale('ko', 'KR')),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SpaceHeight(24,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text('경기를 추가하시나요?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            ),
                          ),
                        ),
                        if (_selectedMatch != null)
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _bottomSheet(context),
                                child: Text('변경',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  ),
                                ),

                              ),
                              const SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedMatch = null;
                                  });
                                },
                                child: Text('삭제',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    _selectedMatch == null
                      ? GestureDetector(
                          onTap: () {
                            _bottomSheet(context);
                          },
                          child: CustomContainer(
                            height: 80,
                            backgroundColor: const Color(0xFFF2F4F4),
                            child: Center(
                              child: Icon(Icons.add_rounded,
                                color: Theme.of(context).colorScheme.onSecondary,
                                size: 30,
                              ),
                            ),
                          ),
                        )
                      : MatchListWidget(
                          match: _selectedMatch!,
                          backgroundColor: Theme.of(context).colorScheme.onTertiary,
                        ),
                  ],
                ),
                const SizedBox(height: 24,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (!isSync) {
            _submit();
          }
        },
        child: keyboardHeight < 50
          ? Container(
              height: 50.sp,
              margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: keyboardHeight + safeArea + 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary.withOpacity(_isDisabled || isSync ? 0.6 : 1),
                borderRadius: BorderRadius.circular(16.sp),
              ),
              child: Center(
                child: Text('등록하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                ),
              ),
            )
          : Container(
              height: 50,
              margin: EdgeInsets.only(bottom: keyboardHeight + safeArea),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary.withOpacity(_isDisabled ? 0.6 : 1),
              ),
              child: Center(
                child: Text('등록하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                ),
              ),
            )
      ),
    );
  }

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  );

  final OutlineInputBorder _inputErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Color(0xFFFF5D5D),
    )
  );

  TextStyle _hintTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.tertiary,
    fontWeight: FontWeight.w400,
    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
  );


}
