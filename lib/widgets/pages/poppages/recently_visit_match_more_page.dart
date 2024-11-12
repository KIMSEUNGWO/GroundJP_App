
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/notifier/recently_match_notifier.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentlyVisitMatchMoreWidget extends ConsumerWidget {
  const RecentlyVisitMatchMoreWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<MatchView> items = ref.watch(recentlyMatchNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('최근 본 매치'),
        actions: [

          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  ref.read(recentlyMatchNotifier.notifier).removeAll();
                },
                child: Text('전체삭제',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            )
        ],
      ),
      body: items.isEmpty ?
      Center(
        child: Text('내역이 존재하지 않습니다',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
          ),
        ),
      ) :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          separatorBuilder: (context, index) => const SizedBox(height: 16,),
          itemCount: items.length,
          itemBuilder: (context, index) {
            MatchView data = items[index];
            return Dismissible(
              key: Key('${data.matchId}'),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                ref.read(recentlyMatchNotifier.notifier).remove(data);
              },
              child: MatchListWidget(
                match: data,
                formatType: DateFormatType.DATETIME,
              ),
            );
          },
        ),
      ),
    );
  }

}
