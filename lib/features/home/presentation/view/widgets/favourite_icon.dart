import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants.dart';
import '../../../data/models/event.dart';
import '../../view_model/favourite_cubit/favourite_cubit.dart';
import '../../view_model/favourite_cubit/favourite_state.dart';

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({super.key, required this.eventModel});
  final EventModel eventModel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          final isFav = (state is FavoriteSuccess)
              ? state.favorites.any((fav) => fav.title == eventModel.title)
              : false;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isFav ? Icons.star : Icons.star_border_purple500_sharp,
                color: const Color(kPrimaryColor),
                size: 30,
              ),
              onPressed: () async {
                final cubit = context.read<FavoriteCubit>();
                if (isFav) {
                  await cubit.removeFromFavorite(eventModel.title);
                } else {
                  await cubit.addToFavorite(eventModel);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
