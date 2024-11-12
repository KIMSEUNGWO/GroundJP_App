

import 'package:flutter/material.dart';
import 'package:groundjp/domain/user/user_simp.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/component/user_profile_wiget.dart';

class BoardUserProfileWidget extends StatelessWidget {

  final UserSimp user;
  const BoardUserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserProfileWidget(
          diameter: 25,
          image: user.profile,
        ),
        const SpaceWidth(6),
        Text(user.nickname,)
      ],
    );
  }
}
