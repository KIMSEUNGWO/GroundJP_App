
import 'package:flutter/material.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/settings_menu_form.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsHelpWidget extends StatelessWidget {
  const SettingsHelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('고객센터/도움말'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const SpaceHeight(36),
              ...ListSeparatorBuilder(
                separator: const SpaceHeight(40),
                items: [
                  SettingsMenuFormWidget(
                    title: '고객센터',
                    menus: [
                      SettingsMenuWidget(
                        menuTitle: '도움말',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                      ),
                      SettingsMenuWidget(
                        menuTitle: '고객센터 문의',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                      ),
                      SettingsMenuWidget(
                        menuTitle: '서비스 개선 문의',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  SettingsMenuFormWidget(
                    title: '약관 및 정책',
                    menus: [
                      SettingsMenuWidget(
                        menuTitle: '이용약관',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                        onPressed: () {

                        },
                      ),
                      SettingsMenuWidget(
                        menuTitle: '개인정보처리방침',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                      ),
                      SettingsMenuWidget(
                        menuTitle: '오픈소스 라이선스',
                        action: Icon(Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ).build(),
            ],
          ),
        ),
      ),
    );
  }
}
