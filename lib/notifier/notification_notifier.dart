
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/component/local_storage.dart';
import 'package:groundjp/component/permission_handler.dart';
import 'package:groundjp/domain/refund/refund.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationNotifier extends StateNotifier<FlutterLocalNotificationsPlugin> {
  NotificationNotifier() : super(FlutterLocalNotificationsPlugin());

  init() async {
    await PermissionHandler().init();
    AndroidInitializationSettings android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
    await state.initialize(settings);
  }

  _notificationDetails() {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        "GroundJP",
        "show_test",
        channelDescription: "Test Local notification",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }


  show({required int id, required String title, required String body}) async {
    await state.show(id, title, body, _notificationDetails());
  }

  scheduleMatchDate({required int matchId,  required DateTime matchDate}) async {


    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    int notificationId = NotificationType.MATCH.idGenerator();

    show(id: notificationId, title: '신청 완료', body: '매치 신청이 완료되었습니다.');

    // 알림이 꺼져있으면 알림 스케쥴을 만들지 않는다
    bool isOn = LocalStorage.instance.getMatchNotification();
    if (!isOn) return;
    // DateTime oneHourBefore = matchDate.subtract(const Duration(hours: 1));
    // DateTime twoHoursBefore = matchDate.subtract(const Duration(hours: 2));
    // DateTime thirtyMinutesBefore = matchDate.subtract(const Duration(minutes: 30));
    DateTime oneHourBefore = matchDate.subtract(const Duration(seconds: 30));
    DateTime twoHoursBefore = matchDate.subtract(const Duration(seconds: 20));
    DateTime thirtyMinutesBefore = matchDate.subtract(const Duration(seconds: 10));

    _addSchedule(id: notificationId + 1, title: '경기알림', body: '경기시작 2시간 전이에요.', time: oneHourBefore, payload: NotificationType.MATCH.payload(matchId, 1));
    _addSchedule(id: notificationId + 2, title: '경기알림', body: '경기시작 1시간 전이에요.', time: twoHoursBefore, payload: NotificationType.MATCH.payload(matchId, 2));
    _addSchedule(id: notificationId + 3, title: '경기알림', body: '경기시작 30분 전이에요. 곧 경기가 시작됩니다.', time: thirtyMinutesBefore, payload: NotificationType.MATCH.payload(matchId, 3));

  }

  matchCancel({required int matchId, required Refund refund}) async {
    const type = NotificationType.MATCH;
    int notificationId = type.idGenerator();

    show(id: notificationId, title: '매치 취소', body: '매치가 취소되었습니다.');
    show(id: notificationId + 1, title: '환불', body: '결제금액 : ${AccountFormatter.format(refund.payAmount)}\n환불금액 : ${AccountFormatter.format(refund.refundAmount)}');

    List<PendingNotificationRequest> data = await state.pendingNotificationRequests();

    List<int> cancelNotificationList = data.where((e) => NotificationType.MATCH.isDetailPayloadData(matchId, e.payload)).map((e) => e.id).toList();
    for (int index in cancelNotificationList) {
      state.cancel(index);
    }
  }


  _addSchedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
    String? payload,
  }) {
    if (time.isBefore(DateTime.now())) {
      return;
    }
    state.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      _notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  void scheduleCancel(NotificationType type) async {
    List<PendingNotificationRequest> data = await state.pendingNotificationRequests();
    List<int> cancelNotificationList = data.where((e) => NotificationType.MATCH.isPayloadData(e.payload)).map((e) => e.id).toList();
    for (int index in cancelNotificationList) {
      state.cancel(index);
    }
  }


}

final notificationNotifier = StateNotifierProvider<NotificationNotifier, FlutterLocalNotificationsPlugin>((ref) => NotificationNotifier());


enum NotificationType {

  MATCH;

  int idGenerator() {
    return name.hashCode + Random().nextInt(1000000);
  }
  String payload(int id, int number) {
    return '${name}_${id}_$number';
  }

  bool isDetailPayloadData(int id, String? payload) {
    if (payload == null) return false;
    return payload.startsWith('${name}_$id');
  }

  bool isPayloadData(String? payload){
    if (payload == null) return false;
    return payload.startsWith(name);
  }

  void forEach(int id, Function(int) run) {
    for (int i=id+1;i<=id+9;i++) {
      run(i);
    }
  }

}