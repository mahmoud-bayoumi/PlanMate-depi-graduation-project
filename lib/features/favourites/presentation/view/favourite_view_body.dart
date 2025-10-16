import 'package:flutter/material.dart';
import 'widgets/list_view_event_item.dart';

class FavouriteViewBody extends StatelessWidget {
  const FavouriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Favourite List',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        SizedBox(height: 20),
        Expanded(child: ListViewEventItem()),
      ],
    );
  }
}
