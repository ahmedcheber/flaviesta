import 'package:flutter/material.dart';
import 'anniversarypage-screen.dart';
import 'weddingpage-screen.dart';
import 'cupcakespage-screen.dart';
import 'glutenfreepage-screen.dart';
import 'cakedetailspage-screen.dart';
import 'categorypage-screen.dart';
import 'basketpage-screen.dart';
import 'profilepage-screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Cake> _cakes = CakeData.getCakes();
  List<Cake> _filteredCakes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCakes = _cakes; // Initially display all cakes
    _searchController.addListener(_filterCakes);
  }

  void _filterCakes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCakes = _cakes.where((cake) {
        return cake.name.toLowerCase().contains(query);
      }).toList();
    });
  }

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
    } else if (category == 'Cupcakes') {
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
        MaterialPageRoute(builder: (context) => CategoryPage(category: category)),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
        automaticallyImplyLeading: false, // <- This removes the back button
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
                controller: _searchController,
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
                  _buildCategoryChip(context, 'Cupcakes'),
                  _buildCategoryChip(context, 'Gluten-Free'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Special Packs For You',
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
                itemCount: _filteredCakes.length,
                itemBuilder: (context, index) {
                  Cake cake = _filteredCakes[index];
                  return GestureDetector(
                    onTap: () => _onCakeTap(
                      context,
                      cake.name,
                      cake.image,
                      cake.price,
                      cake.rating,
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
                                cake.image,
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
                                  cake.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 114, 88, 65),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cake.price,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 160, 138, 108),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < cake.rating.round()
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
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            // Already on Home, do nothing or maybe scroll to top
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BasketPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
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

class Cake {
  final String name;
  final String image;
  final String price;
  final double rating;

  Cake({
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
  });
}

class CakeData {
  static List<Cake> getCakes() {
    return [
      Cake(name: 'Duo Délice', image: 'images/cake0.png', price: '\$50.99', rating: 4.5),
      Cake(name: 'Cake & Crumbs', image: 'images/cake1.png', price: '\$40.00', rating: 4.0),
      Cake(name: 'Mini & Me', image: 'images/cake2.png', price: '\$60.00', rating: 5.0),
      Cake(name: 'Sweetheart Pack', image: 'images/cake3.png', price: '\$70.99', rating: 4.8),
    ];
  }
}
