import 'package:flutter/material.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Basket',
          style: TextStyle(
            fontFamily: 'BridgetLily',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 114, 88, 65),
          ),
        ),
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.shopping_basket_outlined,
              size: 100,
              color: Color.fromARGB(255, 160, 138, 108),
            ),
            SizedBox(height: 20),
            Text(
              'Your basket is empty!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 114, 88, 65),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Start adding some delicious cakes!',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 160, 138, 108),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
