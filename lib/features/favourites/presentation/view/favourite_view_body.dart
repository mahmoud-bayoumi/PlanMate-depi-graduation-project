import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/presentation/view_model/favourite_cubit/favourite_cubit.dart';
import '../../../home/presentation/view_model/favourite_cubit/favourite_state.dart';
import 'widgets/list_view_event_item.dart';
import '../../../home/data/models/event.dart';

class FavouriteViewBody extends StatelessWidget {
  const FavouriteViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FavoriteSuccess) {
          final List<EventModel> favorites = state.favorites;
          if (favorites.isEmpty) {
            return const Center(
              child: Text('No favorites yet', style: TextStyle(fontSize: 30)),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Favourite List',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
              const SizedBox(height: 20),
              Expanded(child: ListViewEventItem(events: favorites)),
            ],
          );
        }
        if (state is FavoriteError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      context.read<FavoriteCubit>().fetchFavorites(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        //fallback
        return const SizedBox.shrink();
      },
    );
  }
}