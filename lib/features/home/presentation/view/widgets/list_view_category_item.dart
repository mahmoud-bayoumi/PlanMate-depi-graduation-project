import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/category.dart';
import '../../view_model/get_category_cubit/get_category_cubit.dart';
import 'category_item.dart';

class ListViewCategoryItem extends StatelessWidget {
  const ListViewCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    List<CategoryModel> categorys = BlocProvider.of<GetCategoryCubit>(
      context,
    ).categoryList;
    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categorys.length,
        padding: const EdgeInsets.only(left: 20, right: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CategoryItem(
              isSelected: index == 1,
              category: categorys[index],
            ),
          );
        },
      ),
    );
  }
}
