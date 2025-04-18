// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart' show AppBar, BackButton, BorderRadius, BorderSide, BottomNavigationBar, BottomNavigationBarItem, BoxFit, BuildContext, Card, Center, Chip, ClipRRect, Color, Colors, Column, CrossAxisAlignment, EdgeInsets, ElevatedButton, FontWeight, GestureDetector, GridView, Icon, IconButton, Icons, Image, InputDecoration, MainAxisAlignment, MaterialApp, MaterialPageRoute, Navigator, NeverScrollableScrollPhysics, OutlineInputBorder, Padding, RoundedRectangleBorder, Row, SafeArea, Scaffold, ScaffoldMessenger, SingleChildScrollView, SizedBox, SliverGridDelegateWithFixedCrossAxisCount, SnackBar, State, StatefulWidget, StatelessWidget, Text, TextButton, TextEditingController, TextField, TextInputType, TextStyle, VoidCallback, Widget, WidgetsFlutterBinding, Wrap, runApp;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlaviestaApp());
}

class FlaviestaApp extends StatelessWidget {
  const FlaviestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flaviesta',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// ---------------- SplashScreen ----------------
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.png', width: 350),
            const SizedBox(height: 5),
            const Text(
              'Flaviesta',
              style: TextStyle(
                fontFamily: 'BridgetLily',
                fontSize: 55,
                color: Color.fromARGB(255, 160, 138, 108),
              ),
            ),
            const Text(
              'Discover the magic of freshly baked !',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 160, 138, 108),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 247, 232, 189),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get started',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 114, 88, 65),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BridgetLily',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- AuthScreen ----------------
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset('images/logo.png', width: 300),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPageDemo()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 160, 138, 108),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BridgetLily', 
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color.fromARGB(255, 160, 138, 108), width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 160, 138, 108),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BridgetLily',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- LoginPageDemo ----------------

class LoginPageDemo extends StatefulWidget {
  const LoginPageDemo({super.key});

  @override
  State<LoginPageDemo> createState() => _LoginPageDemoState();
}

class _LoginPageDemoState extends State<LoginPageDemo> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: '', // Use default font
          color: Colors.white,
        ),
      ),
        backgroundColor: Colors.brown[200],
      ),
    );
  }

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter both email and password.');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        // ignore: duplicate_ignore
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      }
      _showMessage(errorMessage);
    } catch (e) {
      _showMessage('Something went wrong. Please try again.');
      // ignore: duplicate_ignore
      // ignore: avoid_print
      print('Login Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color.fromARGB(255, 114, 88, 65)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset('images/logo.png', width: 120),
                const SizedBox(height: 20),
                const Text(
                  'Flaviesta',
                  style: TextStyle(
                    fontFamily: 'BridgetLily',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 114, 88, 65),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: _buildInputDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontFamily: ''),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: _buildInputDecoration(
                    'Password',
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    isHidden: _obscureText,
                  ),
                  style: const TextStyle(fontFamily: ''),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Color.fromARGB(255, 160, 138, 108), width: 1.5),
                    backgroundColor: const Color.fromARGB(255, 247, 232, 189),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 114, 88, 65),
                      fontFamily: 'BridgetLily',
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 160, 138, 108),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 160, 138, 108),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText,
      {bool isPassword = false, VoidCallback? toggleVisibility, bool isHidden = true}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color.fromARGB(255, 160, 138, 108)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: const Color.fromARGB(255, 160, 138, 108),
              ),
              onPressed: toggleVisibility,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: '', // default font
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color.fromARGB(255, 114, 88, 65)),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset('images/logo.png', width: 100),
                const SizedBox(height: 20),
                const Text(
                  'Flaviesta',
                  style: TextStyle(
                    fontFamily: 'BridgetLily',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 114, 88, 65),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color.fromARGB(255, 160, 138, 108),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _fullNameController,
                  decoration: _buildInputDecoration('Full Name'),
                  keyboardType: TextInputType.name,
                  style: const TextStyle(fontFamily: ''),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: _buildInputDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontFamily: ''),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _phoneController,
                  decoration: _buildInputDecoration('Phone Number'),
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontFamily: ''),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _addressController,
                  decoration: _buildInputDecoration('Address'),
                  keyboardType: TextInputType.streetAddress,
                  style: const TextStyle(fontFamily: ''),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _buildInputDecoration(
                    'Password',
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    isHidden: _obscurePassword,
                  ),
                  style: const TextStyle(fontFamily: ''),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    final fullName = _fullNameController.text.trim();
                    final email = _emailController.text.trim();
                    final phone = _phoneController.text.trim();
                    final address = _addressController.text.trim();
                    final password = _passwordController.text.trim();

                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    final passwordRegex =
                        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                    final phoneRegex = RegExp(r'^(07|06|05)\d{8}$');

                    if (fullName.isEmpty ||
                        email.isEmpty ||
                        phone.isEmpty ||
                        address.isEmpty ||
                        password.isEmpty) {
                      _showMessage('Please fill in all the fields.');
                      return;
                    }

                    if (!emailRegex.hasMatch(email)) {
                      _showMessage('Please enter a valid email address.');
                      return;
                    }

                    if (!passwordRegex.hasMatch(password)) {
                      _showMessage(
                          'Password must be at least 8 characters and include letters and numbers.');
                      return;
                    }

                    if (!phoneRegex.hasMatch(phone)) {
                      _showMessage(
                          'Phone must start with 07, 06, or 05 and be exactly 10 digits.');
                      return;
                    }

                    try {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .set({
                        'fullName': fullName,
                        'email': email,
                        'phone': phone,
                        'address': address,
                      });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    } catch (e) {
                      print('Sign Up Error: $e');
                      _showMessage('Sign up failed. Please try again.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 160, 138, 108), width: 1.5),
                    backgroundColor:
                        const Color.fromARGB(255, 247, 232, 189),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 114, 88, 65),
                      fontFamily: 'BridgetLily',
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPageDemo()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 160, 138, 108),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText,
      {bool isPassword = false,
      VoidCallback? toggleVisibility,
      bool isHidden = true}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle:
          const TextStyle(color: Color.fromARGB(255, 160, 138, 108)),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: const Color.fromARGB(255, 160, 138, 108),
              ),
              onPressed: toggleVisibility,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onCategoryTap(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(category: category),
      ),
    );
  }

  void _onCakeTap(BuildContext context, String price, double rating) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CakeDetailsPage(price: price, rating: rating),
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
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
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
class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: $category'),
      ),
      body: Center(
        child: Text('Display cakes for "$category" here.'),
      ),
    );
  }
}

class CakeDetailsPage extends StatelessWidget {
  final String price;
  final double rating;
  const CakeDetailsPage({super.key, required this.price, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cake Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Price: $price'),
            const SizedBox(height: 10),
            Text('Rating: $rating ⭐'),
          ],
        ),
      ),
    );
  }
}
