

import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:flutter/material.dart';

class PolicyWidget extends StatefulWidget {

  final Function(bool) canSubmit;

  const PolicyWidget({super.key, required this.canSubmit});

  @override
  State<PolicyWidget> createState() => _PolicyWidgetState();
}

class _PolicyWidgetState extends State<PolicyWidget> {

  bool _policy1 = false;
  bool _policy2 = false;
  bool _policy3 = false;

  _policy1Toggle() {
    setState(() => _policy1 = !_policy1);
    _canSubmit();
  }
  _policy2Toggle() {
    setState(() => _policy2 = !_policy2);
    _canSubmit();
  }
  _policy3Toggle() {
    setState(() => _policy3 = !_policy3);
    _canSubmit();
  }

  _canSubmit() {
    widget.canSubmit(_policy1 && _policy2 && _policy3);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _policy1Toggle,
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_rounded,
                    size: 23,
                    color: _policy1
                      ? Theme.of(context).colorScheme.onPrimary
                      : const Color(0xFFDDDDDD),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('[필수] 서비스 이용약관',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('자세히',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline
              ),
            )
          ],
        ),
        const SpaceHeight( 10,),
        Row(
          children: [
            GestureDetector(
              onTap: _policy2Toggle,
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_rounded,
                    size: 23,
                    color: _policy2
                        ? Theme.of(context).colorScheme.onPrimary
                        : const Color(0xFFDDDDDD),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('[필수] 개인(신용)정보 수집 및 이용 동의',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('자세히',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline
              ),
            )
          ],
        ),
        const SpaceHeight( 10,),
        Row(
          children: [
            GestureDetector(
              onTap: _policy3Toggle,
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_rounded,
                    size: 23,
                    color: _policy3
                        ? Theme.of(context).colorScheme.onPrimary
                        : const Color(0xFFDDDDDD),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('[필수] 개인(신용)정보 제3자 제공 동의',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('자세히',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline
              ),
            )
          ],
        ),

      ],
    );
  }
}
