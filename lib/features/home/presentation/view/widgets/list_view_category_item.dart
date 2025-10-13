import 'package:flutter/material.dart';
import 'package:planmate_app/features/home/presentation/view/widgets/category_item.dart';

class ListViewCategoryItem extends StatelessWidget {
  const ListViewCategoryItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        padding: const EdgeInsets.only(left: 20, right: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CategoryItem(
              isSelected: index == 1,
            ),
          );
        },
      ),
    );
  }
}
