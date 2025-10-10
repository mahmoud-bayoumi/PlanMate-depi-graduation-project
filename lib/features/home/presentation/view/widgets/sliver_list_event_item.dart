import 'package:flutter/material.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/event_item.dart';
class SliverListEventItem extends StatelessWidget {
  const SliverListEventItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 5,
        (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 10, bottom: 10),
            child: EventItem(
              isFav: index == 0 ? true : false,
            ),
          );
        },
      ),
    );
  }
}
