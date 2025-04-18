import 'package:flutter/material.dart';

class CustomizePage extends StatelessWidget {
  const CustomizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customize Cake")),
      body: const Center(child: Text("Customize your cake here!")),
    );
  }
}
