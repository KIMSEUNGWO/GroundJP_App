import 'package:intl/intl.dart';

class DateTimeFormatter {

  static String remainDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inSeconds < 60) {
      return '잠시 후';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 후';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 후';
    } else {
      return '${difference.inDays}일 후';
    }
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}초 전';
      // return 'time'.tr(gender: 'seconds', args: ['${difference.inSeconds}']);
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
      // return 'time'.tr(gender: 'minutes', args: ['${difference.inMinutes}']);
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
      // return 'time'.tr(gender: 'hours', args: ['${difference.inHours}']);
    } else if (difference.inDays == 1) {
      return '어제 ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
      // return 'time'.tr(gender: 'days', args: ['${difference.inDays}']);
    } else if (difference.inDays < 365) {
      return DateFormat('MM-dd').format(date);
    } else {
      return DateFormat('yy-MM-dd').format(date);
    }
  }


}