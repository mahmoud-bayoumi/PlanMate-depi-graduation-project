import 'package:flutter/material.dart';
import 'package:planmate_app/features/favourites/presentation/view/widgets/list_view_event_item.dart';

class FavouriteViewBody extends StatelessWidget {
  const FavouriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Favourite List',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListViewEventItem(),
        ),
      ],
    );
  }
}
