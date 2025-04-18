// ignore_for_file: unused_import

import 'package:flaviesta/pages/main.dart';
import 'package:flutter/material.dart';
import 'category_page.dart';
import 'cake_details_page.dart';
import 'customize_page.dart';
import 'anniversarypage_page.dart';
import 'basket_page.dart';


class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  void _onCategoryTap(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => categoryPage(category: category),
      ),
    );
  }

  void _onCakeTap(BuildContext context, String price, double rating) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CakeDetailsPage(
              price: price,
              rating: rating,
              cakeName: null,
              image: null,
            ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    return GestureDetector(
      onTap: () => _onCategoryTap(context, category),
      child: Chip(
        label: Text(category),
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 114, 88, 65),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildCakeCard(BuildContext context, String image, String price, double rating) {
    return GestureDetector(
      onTap: () => _onCakeTap(context, price, rating),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(image,
                  width: double.infinity, height: 150, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 160, 138, 108),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '$rating',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 160, 138, 108),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> cakeImages = [
      'images/cake0.jpg',
      'images/cake1.jpg',
      'images/cake2.jpg',
      'images/cake3.jpg',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
        title: const Text(
          'Find and Get Your Best Cake',
          style: TextStyle(
            fontFamily: 'BridgetLily',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 114, 88, 65),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for cakes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(251, 221, 210, 1),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Browse by Category',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 114, 88, 65),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  _buildCategoryChip(context, 'Anniversary'),
                  _buildCategoryChip(context, 'Wedding'),
                  _buildCategoryChip(context, 'Traditional'),
                  _buildCategoryChip(context, 'Gluten-Free'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Featured Cakes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 114, 88, 65),
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: cakeImages.length,
                itemBuilder: (context, index) {
                  return _buildCakeCard(
                    context,
                    cakeImages[index],
                    '1500 DA',
                    4.5,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
