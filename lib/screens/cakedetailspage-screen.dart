import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CakeDetailsPage extends StatefulWidget {
  final String cakeName;
  final String image;
  final String price;
  final double rating;

  const CakeDetailsPage({
    super.key,
    required this.cakeName,
    required this.image,
    required this.price,
    required this.rating,
  });

  @override
  State<CakeDetailsPage> createState() => _CakeDetailsPageState();
}

class _CakeDetailsPageState extends State<CakeDetailsPage> {
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  Future<void> addToBasket() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final double unitPrice = double.tryParse(
              widget.price.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0;
      final double totalPrice = unitPrice * quantity;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('basket')
          .add({
        'cakeName': widget.cakeName,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'image': widget.image,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$quantity x ${widget.cakeName} added to your basket!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to add items to your basket.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
        title: const Text(
          'Cake Details',
          style: TextStyle(
            color: Color.fromARGB(255, 114, 88, 65),
            fontWeight: FontWeight.bold,
            fontFamily: 'BridgetLily',
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        widget.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cakeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.price,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < widget.rating.round()
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: decrement,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.brown,
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: increment,
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.brown,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: addToBasket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
                  foregroundColor: const Color.fromARGB(255, 114, 88, 65),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 160, 138, 108),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
