

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSheet<T> {
  
  final List<ActionTile<T>> _actions;

  ActionSheet({required List<ActionTile<T>> actions}) : _actions = actions;

  void showBottomActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소'),
          ),
          actions: _actions.map((action) {
            return CupertinoActionSheetAction(
              onPressed: () {
                action.onPressed(action.type);
                Navigator.of(context).pop();
              },
              child: Text(action.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

}


class ActionTile<T> {

  final String title;
  final T? type;
  final Function(T?) onPressed;

  ActionTile({required this.title, required this.type, required this.onPressed});

}