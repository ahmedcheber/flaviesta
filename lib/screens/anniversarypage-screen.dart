import 'package:flutter/material.dart';
import 'cakedetailspage-screen.dart';
class AnniversaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> anniversaryCakes = [
    {
      'name': 'Chocolate Celebration',
      'price': 39.99,
      'image': 'images/aniv1.jpg',
      'rating': 4.8,
    },
    {
      'name': 'Vanilla Bliss',
      'price': 34.50,
      'image': 'images/aniv2.jpg',
      'rating': 4.7,
    },
    {
      'name': 'Red Velvet Charm',
      'price': 42.00,
      'image': 'images/aniv3.jpg',
      'rating': 4.9,
    },
    {
      'name': 'Strawberry Dream',
      'price': 38.25,
      'image': 'images/aniv4.jpg',
      'rating': 5.0,
    },
  ];

  AnniversaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
        title: const Text(
          'Anniversary Cakes',
          style: TextStyle(
            fontFamily: 'BridgetLily',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 114, 88, 65),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: anniversaryCakes.length,
          itemBuilder: (context, index) {
            final cake = anniversaryCakes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CakeDetailsPage(
                      cakeName: cake['name'],
                      price: '\$${cake['price']}',
                      rating: cake['rating'],
                      image: cake['image'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          cake['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cake['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '\$${cake['price'].toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < cake['rating'].round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}