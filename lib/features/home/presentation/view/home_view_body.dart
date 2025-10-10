import 'package:flutter/material.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/chat_image_icon.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/list_view_category_item.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/search_text_field.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/sliver_list_event_item.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/title_text.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: SearchTextField(),
                ),
                const ChatImageIcon(),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TitleText(text: 'Category'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 15)),
        SliverToBoxAdapter(
          child: ListViewCategoryItem(),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TitleText(text: 'Comedy Events'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 15)),
        SliverListEventItem(),
      ],
    );
  }
}
