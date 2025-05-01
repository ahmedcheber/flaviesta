import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'paymentPage.dart'; // Make sure this is the correct path

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateQuantity(String docId, int newQuantity, double unitPrice) async {
    if (newQuantity < 1) return;
    final newTotal = unitPrice * newQuantity;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('basket')
        .doc(docId)
        .update({
      'quantity': newQuantity,
      'totalPrice': newTotal,
    });
  }

  Future<void> deleteItem(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('basket')
        .doc(docId)
        .delete();
  }

  void navigateToPaymentPage(Map<String, dynamic> itemData) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentPage(itemData: itemData),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('Please sign in to view your basket.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Basket',
          style: TextStyle(
            fontFamily: 'BridgetLily',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 114, 88, 65),
          ),
        ),
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('basket')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final basketItems = snapshot.data!.docs;

          if (basketItems.isEmpty) {
            return const Center(child: Text('Your basket is empty.'));
          }

          return ListView.builder(
            itemCount: basketItems.length,
            itemBuilder: (context, index) {
              final doc = basketItems[index];
              final data = doc.data() as Map<String, dynamic>;

              final String cakeName = data['cakeName'];
              final String imagePath = data['image'];
              final int quantity = data['quantity'];
              final double totalPrice = (data['totalPrice'] as num).toDouble();
              final double unitPrice = totalPrice / quantity;

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              imagePath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cakeName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => updateQuantity(doc.id, quantity - 1, unitPrice),
                                    ),
                                    Text(quantity.toString()),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => updateQuantity(doc.id, quantity + 1, unitPrice),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteItem(doc.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => navigateToPaymentPage(data),
                          child: const Text('Order Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(251, 221, 210, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
