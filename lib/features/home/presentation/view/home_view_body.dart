import 'package:flutter/material.dart';
import 'widgets/chat_image_icon.dart';
import 'widgets/list_view_category_item.dart';
import 'widgets/search_text_field.dart';
import 'widgets/sliver_list_event_item.dart';
import 'widgets/title_text.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
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
        SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TitleText(text: 'Comedy Events'),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 15)),
        SliverListEventItem(),
      ],
    );
  }
}
