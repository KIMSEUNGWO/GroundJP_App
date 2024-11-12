
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:flutter/material.dart';

class DetailRoleFormWidget extends StatelessWidget {
  const DetailRoleFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailDefaultFormWidget(
      title: '매치 진행 방식',
      child: CustomContainer(
        child: const Column(
          children: [
            _RoleFormWidget(
              title: '매치 규칙',
              items: [
                '모든 파울은 사이드라인에서 킥인',
                '골키퍼에게 백패스 가능. 손으로는 잡으면 안 돼요',
                '사람을 향한 태클 금지',
              ]
            ),
            _RoleFormWidget(
              title: '진행 방식',
              items: [
                '풋살화와 개인 음료만 준비하세요',
                '골키퍼와 휴식을 공평하게 돌아가면서 해요',
                '친구끼리 와도 팀 실력이 맞지 않으면 다른 팀이 될 수 있어요.',
              ]
            ),
            _RoleFormWidget(
              title: '이것만은 꼭 지켜주세요',
              items: [
                '서로 존중하고 격려하며 함께 즐겨요',
              ]
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleFormWidget extends StatelessWidget {

  final String title;
  final List<String> items;

  const _RoleFormWidget({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: items.map((item) => _ListItem(text: item)).toList()
          ),
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {

  final String text;

  const _ListItem({required this.text,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 3),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

