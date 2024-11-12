
import 'package:groundjp/domain/enums/receipt_enum.dart';

class Receipt {

  final String title;
  final ReceiptType? type;
  final DateTime date;
  final int useCash;
  final int remainCash;

  Receipt.fromJson(Map<String, dynamic> json):
    title = json['title'],
    type = ReceiptType.valueOf(json['type']),
    date = DateTime.parse(json['date']),
    useCash = json['useCash'],
    remainCash = json['remainCash'];

  Receipt({required this.title, required this.type, required this.date, required this.useCash, required this.remainCash});

}