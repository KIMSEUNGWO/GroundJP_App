

import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:flutter/material.dart';

class MatchStatusWidget extends StatelessWidget {

  final MatchStatus matchStatus;

  const MatchStatusWidget({super.key, required this.matchStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 55),
      decoration: BoxDecoration(
        color: matchStatus.backgroundColor(context),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
      child: Text(matchStatus.ko,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
