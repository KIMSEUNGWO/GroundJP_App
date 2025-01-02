

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/component/local_storage.dart';
import 'package:groundjp/notifier/notification_notifier.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/app.dart';

class InitApp extends ConsumerStatefulWidget {
  const InitApp({super.key});

  @override
  ConsumerState<InitApp> createState() => _InitAppState();
}

class _InitAppState extends ConsumerState<InitApp> {


  init() async {
    await LocalStorage.initInstance();
    ref.read(regionProvider.notifier).init();
    await ref.read(notificationNotifier.notifier).init();
  }

  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
