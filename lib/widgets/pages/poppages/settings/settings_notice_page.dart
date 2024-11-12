
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:groundjp/api/service/setting_service.dart';
import 'package:groundjp/component/datetime_formatter.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/domain/notice.dart';
import 'package:groundjp/widgets/component/pageable_listview.dart';
import 'package:groundjp/widgets/pages/poppages/settings/settings_notice_detail_page.dart';
import 'package:intl/intl.dart';

class SettingsNoticeWidget extends StatefulWidget {
  const SettingsNoticeWidget({super.key});

  @override
  State<SettingsNoticeWidget> createState() => _SettingsNoticeWidgetState();
}

class _SettingsNoticeWidgetState extends State<SettingsNoticeWidget> {

  Future<List<Notice>> _pageableNotice(Pageable pageable) async {
    return await SettingService.instance.getPageableNotice(pageable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: PageableListView(
          pageableSize: 15,
          future: _pageableNotice,
          separatorBuilder: (context, index) => const SizedBox(),
          builder: (data) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsNoticeDetailWidget(notice: data);
                },));
              },
              child: Container(
                constraints: const BoxConstraints(
                    minHeight: 80
                ),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 0.5,
                      )
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.title,
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(DateFormat('yyyy년 M월 d일').format(data.createDate),
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      )
    );
  }
}
