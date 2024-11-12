

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSheetItem {

  final Text text;
  final VoidCallback onPressed
  ;

  ActionSheetItem({required this.text, required this.onPressed});
}
class CustomBottomActionSheets {

  static const CustomBottomActionSheets instance = CustomBottomActionSheets();

  const CustomBottomActionSheets();

  void showBottomActionSheet(BuildContext context, List<ActionSheetItem> items) {
    showCupertinoModalPopup(
      context: context,

      builder: (context) {
        return CupertinoActionSheet(
          actions: items.map((item) {
            return CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                item.onPressed();
              },
              child: item.text,
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('뒤로가기'),
          ),
        );
      },
    );
  }


}
