// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class categoryPage extends StatelessWidget {
  final String category;

  const categoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: $category'),
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      ),
      body: Center(
        child: Text(
          'Showing cakes for $category',
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 114, 88, 65),
          ),
        ),
      ),
    );
  }
}
