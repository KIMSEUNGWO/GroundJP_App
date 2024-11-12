
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/match_service.dart';
import 'package:groundjp/api/service/order_service.dart';
import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/open_app.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/refund/refund.dart';
import 'package:groundjp/domain/user/user_profile.dart';
import 'package:groundjp/notifier/coupon_notifier.dart';
import 'package:groundjp/notifier/notification_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/bottom_bar_widget.dart';
import 'package:groundjp/widgets/component/image_detail_view.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/detail_field_form.dart';
import 'package:groundjp/widgets/form/detail_match_form.dart';
import 'package:groundjp/widgets/form/detail_role_form.dart';
import 'package:groundjp/widgets/form/field_image_preview.dart';
import 'package:groundjp/widgets/form/match_statisics_form.dart';
import 'package:groundjp/widgets/pages/poppages/field_detail_page.dart';
import 'package:groundjp/widgets/pages/poppages/user/login_page.dart';
import 'package:groundjp/widgets/pages/poppages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:groundjp/domain/match/match.dart';
import 'package:intl/intl.dart';

import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchDetailWidget extends ConsumerStatefulWidget {

  final int matchId;

  const MatchDetailWidget({super.key, required this.matchId});

  @override
  createState() => _MatchDetailWidgetState();
}

class _MatchDetailWidgetState extends ConsumerState<MatchDetailWidget> {
  
  Match? match;
  bool _loading = true;
  bool _cancelLoading = false;

  _fetchMatch() async {
    final response = await MatchService.instance.getMatch(matchId: widget.matchId);
    ResultCode result = response.resultCode;
    if (result == ResultCode.OK) {
      setState(() {
        match = Match.fromJson(response.data);
        _loading = false;
      });
    } else if (result == ResultCode.MATCH_NOT_EXISTS) {
      if (mounted) {
        Alert.of(context).message(
          message: '존재하지 않는 경기입니다..',
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  _cancelOrder() {
    Alert.of(context).confirm(
      message: '경기를 취소하시겠습니까?\n환불정책에 따라 환불액이 지급됩니다.\n쿠폰은 재사용할 수 있으나 만료된 쿠폰은 자동으로 삭제됩니다.',
      btnMessage: '경기취소',
      onPressed: () {
        _cancelFetch();
      },
    );
  }

  _cancelFetch() async {
    setState(() {
      _cancelLoading = true;
    });

    final response = await OrderService.instance.cancelOrder(matchId: widget.matchId);
    print('response code : ${response.resultCode}');
    if (response.resultCode == ResultCode.OK) {
      ref.read(loginProvider.notifier).refreshCash();
      ref.read(couponNotifier.notifier).init();
      ref.read(notificationNotifier.notifier).matchCancel(matchId: widget.matchId, refund: Refund.fromJson(response.data));

      if (mounted) {
        Alert.of(context).message(
          message: '경기를 취소했습니다.',
          onPressed: () => Navigator.pop(context),
        );
      }
      return;

    } else if (response.resultCode == ResultCode.ORDER_NOT_EXISTS) {
      if (mounted) {
        Alert.of(context).message(
          message: '이미 환불 처리된 경기입니다.',
          onPressed: () => Navigator.pop(context),
        );
      }
      return;
    }

    setState(() {
      _cancelLoading = false;
    });

  }
  
  @override
  void initState() {
    _fetchMatch();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Skeletonizer(
              enabled: _loading,
              child: _loading ? const Text('') : Text(match!.field.title),
            ),
          ),
          body: Skeletonizer(
            enabled: _loading,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageSlider(
                      images: _loading ? [] : match!.field.images.map((image) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ImageDetailView(image: image)
                                  ,fullscreenDialog: true
                              ));
                          },
                          child: image,
                        );
                      }).toList(),
                    ),
                    const SpaceHeight(19,),
                    Text(_loading ? '' :  DateFormat('M월 d일 EEEE HH:mm', 'ko_KR').format(match!.matchDate),
                      style: TextStyle(
                        color: const Color(0xFF686868),
                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceHeight(5,),
                    Text(_loading ? '' : match!.field.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!_loading) {
                          OpenApp.instance.openMaps(link: match!.field.address.link,);
                        }
                      },
                      child: Text(_loading ? '' : match!.field.address.address,
                        style: TextStyle(
                          color: const Color(0xFF686868),
                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SpaceHeight(35,),
                    MatchStatisticsFormWidget(statistics: match?.statistics),
                    MatchDetailFormWidget(match: match),
                    const SpaceHeight(30),
                    FieldDetailFormWidget(field: match?.field),
                    const SpaceHeight(30),
                    const Skeleton.ignore(
                      child: DetailRoleFormWidget(),
                    ),
                    const SpaceHeight(30),
                    Row(
                      children: [
                        Expanded(
                          child: Text('이 구장에서 다음 경기를 찾으시나요?',
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: () {
                            if (!_loading) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return FieldDetailWidget(fieldId: match!.field.fieldId, field: match!.field,);
                                  },)
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Text('더보기',
                                style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.secondary
                                ),
                              ),
                              const SizedBox(width: 2,),
                              Icon(Icons.arrow_forward_ios_rounded,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 12,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40,),


                  ]
                ),
              ),
            ),
          ),
          bottomNavigationBar: Skeletonizer(
            enabled: _loading,
            child: CustomBottomBar(
              height: 80,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('신청하고 게임을 즐겨보세요',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          // TODO Field hourPrice -> Match hourPrice 로 변경해야함
                          Text(_loading ? '' : AccountFormatter.format(match!.price),
                          // Text(_loading ? '' : AccountFormatter.format(0),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                            ),
                          ),
                          Skeleton.ignore(
                            child: Text(_loading ? '' : ' / ${match!.matchHour}시간',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 32,),
                  if (!_loading)
                    _OrderButtonWidget(match: match!, cancel: _cancelOrder),
                ],
              ),
            ),
          ),
        ),

        if (_cancelLoading)
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF111111).withOpacity(0.2)
              ),
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: CupertinoActivityIndicator(radius: 10,),
              ),
            ),
          ),
      ]
    );
  }
}

class _OrderButtonWidget extends ConsumerStatefulWidget {

  final Match match;
  final VoidCallback cancel;

  const _OrderButtonWidget({required this.match, required this.cancel});

  @override
  createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends ConsumerState<_OrderButtonWidget> {

  // 경기 제한 조건에 일치하는지
  bool _constraint = false;

  _initConstraint() {
    UserProfile? user = ref.read(loginProvider.notifier).get();
    if (user == null) return;

    // 성별제한이 남녀무관이 아니고 사용자의 성별과 일치하지 않으면 제한
    if (widget.match.sexType != null && widget.match.sexType != user.sex) {
      setState(() {_constraint = true;});
    }
  }
  @override
  void initState() {
    _initConstraint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          bool hasLogin = ref.read(loginProvider.notifier).has();
          if (!hasLogin) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const LoginWidget();
            }, fullscreenDialog: true));
            return;
          }
          if (widget.match.alreadyJoin) {
            widget.cancel();
            return;
          }
          if (_constraint ||
              widget.match.matchStatus == MatchStatus.FINISHED ||
              widget.match.matchStatus == MatchStatus.CLOSED) {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderWidget(matchId: widget.match.matchId);},
          ));
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _boxColor(context, widget.match.matchStatus, widget.match.alreadyJoin)
          ),
          child: Center(
            child: Skeleton.ignore(
              child: Text(_matchText(widget.match.matchStatus, widget.match.alreadyJoin),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _boxColor(BuildContext context, MatchStatus status, bool alreadyJoin) {
    if (alreadyJoin) return Theme.of(context).colorScheme.error;
    if (_constraint) return Theme.of(context).colorScheme.tertiary;
    return status.backgroundColor(context);
  }

  String _matchText(MatchStatus status, bool alreadyJoin) {
    if (alreadyJoin) return '신청취소';
    if (_constraint) return '신청불가';
    return switch (status) {
      MatchStatus.OPEN => '신청하기',
      MatchStatus.CLOSING_SOON => '마감임박',
      MatchStatus.CLOSED => '마감',
      MatchStatus.FINISHED => '종료',
    };
  }
}

