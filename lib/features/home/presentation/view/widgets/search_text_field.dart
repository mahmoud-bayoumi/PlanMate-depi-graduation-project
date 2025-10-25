import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/get_category_cubit/get_category_cubit.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) {
        BlocProvider.of<GetCategoryCubit>(context).getEventsByCategory(value);
        BlocProvider.of<GetCategoryCubit>(context).selectedCategoryIndex = 1000;
        BlocProvider.of<GetCategoryCubit>(context).nameCategory = value;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search Events Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}