
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:flutter/material.dart';

class MatchExtraDataWidget extends StatelessWidget {
  
  final MatchData matchData;

  const MatchExtraDataWidget({super.key, required this.matchData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _sexTypeColor(context, matchData.sexType),
        dot(context),
        Text(matchData.region!.ko),
        dot(context),
        Text('${matchData.person} vs ${matchData.person} ${matchData.matchCount}파전')
      ],
    );
  }

  Widget _sexTypeColor(BuildContext context, SexType? sexType) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 5, height: 5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color:
                (sexType == SexType.MALE) ? const Color(0xFF3534A5)
                : (sexType == SexType.FEMALE) ? const Color(0xFFFF5D5D)
                : const Color(0xFFFFC645)
          ),
        ),
        Text(SexType.getName(sexType),
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              fontWeight: FontWeight.w400
          ),
        ),
      ],
    );
  }

  Widget dot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text('·',
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary
        ),
      ),
    );
  }
  
}
