import 'package:flutter/material.dart';
import 'cart-item.dart';
class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: $category'),
      ),
      body: Center(
        child: Text('Display cakes for "$category" here.'),
      ),
    );
  }
}