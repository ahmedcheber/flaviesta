import 'package:flutter/material.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Basket")),
      body: const Center(child: Text("Items in your basket will appear here.")),
    );
  }
}
