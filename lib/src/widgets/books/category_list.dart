import 'package:flutter/material.dart';

import 'package:library_app/src/models/category.dart';

class CategoryItem extends StatelessWidget {
  final String name;

  const CategoryItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: SizedBox(
        height: 24.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(name),
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  final List<Category> _category = initialCategories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: List.generate(_category.length, (index) {
            return CategoryItem(name: _category.elementAt(index).name);
          }),
        ),
      ),
    );
  }
}
