
import 'package:flutter/material.dart';
import 'package:groundjp/domain/notice.dart';
import 'package:intl/intl.dart';

class SettingsNoticeDetailWidget extends StatelessWidget {

  final Notice notice;

  const SettingsNoticeDetailWidget({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notice.title),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notice.title,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 36,),
              Text(notice.content,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 50,),
              Text(DateFormat('yyyy년 M월 dd일 EEEE', 'ko-KR').format(notice.createDate),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
