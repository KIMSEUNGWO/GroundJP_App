
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/component/local_storage.dart';
import 'package:groundjp/notifier/notification_notifier.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/component/toogle_button.dart';
import 'package:groundjp/widgets/form/settings_menu_form.dart';
import 'package:groundjp/widgets/pages/poppages/settings/settings_help_page.dart';
import 'package:groundjp/widgets/pages/poppages/settings/settings_notice_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({super.key});

  @override
  createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SpaceHeight(36),
              ...ListSeparatorBuilder(
                separator: const SpaceHeight(40),
                items: [
                  SettingsMenuFormWidget(
                    title: '알림',
                    menus: [
                      SettingsMenuWidget(
                        menuTitle: '경기 시작 전 알림',
                        action: ToggleButton(
                          callback: LocalStorage.instance.getMatchNotification,
                          onChanged: (isOn) {
                            LocalStorage.instance.saveMatchNotification(isOn);
                            if (!isOn) {
                              ref.read(notificationNotifier.notifier).scheduleCancel(NotificationType.MATCH);
                            }
                          },
                        ),
                      ),
                      SettingsMenuWidget(
                        menuTitle: '뭔가의 알림',
                        action: ToggleButton(
                          callback: () {
                            return false;
                          },
                          onChanged: (p0) {

                          },
                        ),
                      ),
                    ],
                  ),

                  SettingsMenuFormWidget(
                    title: '공지사항',
                    menus: [
                      SettingsMenuWidget(
                        menuTitle: '공지사항',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const SettingsNoticeWidget();
                          },));
                        },
                      ),
                      SettingsMenuWidget(
                        menuTitle: '고객센터/도움말',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const SettingsHelpWidget();
                          },));
                        },
                      ),
                      SettingsMenuWidget(
                        menuTitle: '버전정보',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                        onPressed: () {
                          print('???????/');
                        },
                      ),
                    ],
                  ),
                ],
              ).build(),
              const SpaceHeight(50),
              Text('회원탈퇴'),
            ],
          ),
        ),
      ),
    );
  }
}
