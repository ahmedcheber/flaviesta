import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaviesta/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color.fromRGBO(251, 221, 210, 1);  // For the AppBar background color
  final Color backgroundColor = Color.fromRGBO(255, 255, 255, 1);  // Background color
  final Color frameColor = Color.fromARGB(255, 1, 0, 0); // Frame color
  final Color titleColor = Color(0xFFA08A6C); // Used in AppBar and for font

  String name = '';
  String phone = '';
  String address = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      setState(() {
        name = data?['fullName'] ?? 'Full name';
        phone = data?['phone'] ?? '+213 555 123 456';
        address = data?['address'] ?? 'Algiers, Algeria';
        email = user.email ?? 'example@gmail.com';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'BridgetLily',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            _buildInfoText('Name', name),
            _buildInfoText('Email', email),
            _buildInfoText('Phone', phone),
            _buildInfoText('Address', address),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title: ',
              style: TextStyle(
                color: frameColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, 
        foregroundColor: titleColor, // Text color same as AppBar text
        elevation: 6, // More shadow
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      icon: const Icon(Icons.logout),
      label: Text(
        'Logout',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: frameColor, // Text color matches AppBar
        ),
      ),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
