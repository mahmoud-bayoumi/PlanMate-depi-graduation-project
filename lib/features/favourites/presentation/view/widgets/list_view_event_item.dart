import 'package:flutter/material.dart';
import '../../../../home/presentation/view/widgets/event_item.dart';

class ListViewEventItem extends StatelessWidget {
  const ListViewEventItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(left: 15, right: 10, bottom: 20),
          child: EventItem(isFav: true),
        );
      },
    );
  }
}
