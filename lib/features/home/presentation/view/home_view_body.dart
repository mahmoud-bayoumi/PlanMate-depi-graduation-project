import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../view_model/get_category_cubit/get_category_cubit.dart';
import '../view_model/get_category_cubit/get_category_state.dart';
import 'widgets/chat_image_icon.dart';
import 'widgets/list_view_category_item.dart';
import 'widgets/search_text_field.dart';
import 'widgets/sliver_list_event_item.dart';
import 'widgets/title_text.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoryCubit, GetCategoryState>(
      builder: (context, state) {
        if (state is GetCategoryLoading) {
          return const ShimmerLoading();
        } else if (state is GetCategoryFailure) {
          return Center(child: Text(state.error));
        } else if (state is GetEventsByCategorySuccess) {
          return const CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    children: [
                      Expanded(child: SearchTextField()),
                      ChatImageIcon(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TitleText(text: 'Category'),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15)),
              SliverToBoxAdapter(child: ListViewCategoryItem()),
              SliverToBoxAdapter(child: SizedBox(height: 80)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      'Category with this name not found, Try Again!!',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    children: [
                      Expanded(child: SearchTextField()),
                      ChatImageIcon(),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const TitleText(text: 'Category'),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<GetCategoryCubit>(
                            context,
                          ).getCategories();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 15)),
              const SliverToBoxAdapter(child: ListViewCategoryItem()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TitleText(
                    text:
                        '${BlocProvider.of<GetCategoryCubit>(context).nameCategory} Events',
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 15)),
              const SliverListEventItem(),
            ],
          );
        }
      },
    );
  }
}
