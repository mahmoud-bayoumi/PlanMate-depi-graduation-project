import 'package:flutter/material.dart';
import '../../../data/models/category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.isSelected,
    required this.category,
  });
  final bool isSelected;
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 90,
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.blue
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: isSelected ? 0 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadiusGeometry.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              category.image,
              fit: BoxFit.fill,
              width: 150,
              height: 65,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            category.name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
