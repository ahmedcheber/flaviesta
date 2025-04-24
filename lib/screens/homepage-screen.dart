import 'package:flutter/material.dart';
import 'anniversarypage-screen.dart';
import 'weddingpage-screen.dart';
import 'traditionalpage-screen.dart';
import 'glutenfreepage-screen.dart';
import 'cakedetailspage-screen.dart';
import 'categorypage-screen.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onCategoryTap(BuildContext context, String category) {
    if (category == 'Anniversary') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AnniversaryPage()),
      );
    } else if (category == 'Wedding') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WeddingPage()),
      );
    } else if (category == 'Traditional') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TraditionalPage()),
      );
    } else if (category == 'Gluten-Free') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GlutenFreePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CategoryPage(category: category)),
      );
    }
  }

  void _onCakeTap(
    BuildContext context,
    String cakeName,
    String image,
    String price,
    double rating,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CakeDetailsPage(
          cakeName: cakeName,
          image: image,
          price: price,
          rating: rating,
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

  @override
  Widget build(BuildContext context) {
    final List<String> cakeImages = [
      'images/cake0.png',
      'images/cake1.png',
      'images/cake2.png',
      'images/cake3.png',
    ];

    final List<String> cakeNames = [
      'Choco Delight',
      'Vanilla Bliss',
      'Strawberry Dream',
      'Caramel Heaven',
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
                'Special For You',
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
                  return GestureDetector(
                    onTap: () => _onCakeTap(
                      context,
                      cakeNames[index],
                      cakeImages[index],
                      '1500 DA',
                      4.5,
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                cakeImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cakeNames[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 114, 88, 65),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '1500 DA',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 160, 138, 108),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < 4.5.round()
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
        selectedItemColor: const Color.fromARGB(255, 114, 88, 65),
        unselectedItemColor: const Color.fromARGB(255, 160, 138, 108),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: 'Customize',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Basket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}