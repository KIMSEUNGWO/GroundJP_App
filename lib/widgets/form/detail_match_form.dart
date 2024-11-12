
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:flutter/material.dart';
import 'package:groundjp/domain/match/match.dart';

class MatchDetailFormWidget extends StatelessWidget {

  final Match? match;

  const MatchDetailFormWidget({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return DetailDefaultFormWidget(
      title: '경기정보',
      child: Column(
        children: [
          Row(
            children: [
              // CustomContainer(
              //   width: containerWidth,
              //   radius: BorderRadius.circular(10),
              //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              //   child: Row(
              //     children: [
              //       SvgIcon.asset(sIcon: SIcon.star, style: SvgIconStyle(
              //         color: Theme.of(context).colorScheme.secondary
              //       )),
              //       const SizedBox(width: 10,),
              //       Text('제한없음',
              //         style: TextStyle(
              //           color: Theme.of(context).colorScheme.secondary,
              //           fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: CustomContainer(
                  radius: BorderRadius.circular(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Row(
                    children: [
                      SvgIcon.asset(sIcon: SIcon.gender, style: SvgIconStyle(
                          color: Theme.of(context).colorScheme.secondary
                      )),
                      const SizedBox(width: 10,),
                      Text(match == null ? '' : SexType.getName(match!.sexType),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 7,),
              Expanded(
                flex: 2,
                child: CustomContainer(
                  radius: BorderRadius.circular(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Row(
                    children: [
                      SvgIcon.asset(sIcon: SIcon.soccer, style: SvgIconStyle(
                          color: Theme.of(context).colorScheme.secondary
                      )),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Text(match == null ? '' : '${match!.person} vs ${match!.person} ${match!.matchCount}파전',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7,),
          CustomContainer(
            width: double.infinity,
            radius: BorderRadius.circular(10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              children: [
                SvgIcon.asset(sIcon: SIcon.manager, style: SvgIconStyle(
                    color: Theme.of(context).colorScheme.secondary
                )),
                const SizedBox(width: 10,),
                Text('아직 매니저님이 정해지지 않았어요.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
