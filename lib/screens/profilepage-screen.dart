import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // for formatting date
import 'package:flaviesta/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color(0xFFFBDDD2);
  final Color backgroundColor = Colors.white;
  final Color titleColor = const Color(0xFF725841);
  final Color accentColor = const Color(0xFFEAC7B4);

  String name = '';
  String phone = '';
  String address = '';
  String email = '';
  List<Map<String, dynamic>> userOrders = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserOrders();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      setState(() {
        name = data?['fullName'] ?? 'Full Name';
        phone = data?['phone'] ?? '+213 555 123 456';
        address = data?['address'] ?? 'Algiers, Algeria';
        email = user.email ?? 'example@gmail.com';
      });
    }
  }

  Future<void> _loadUserOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .get();
      setState(() {
        userOrders = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id; // Save the order ID for updates
          return data;
        }).toList();
      });
    }
  }

  Future<void> _updateDeliveryDate(String orderId, DateTime newDate) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .update({'deliveryDate': DateFormat('yyyy-MM-dd').format(newDate)});
      _loadUserOrders(); // Refresh orders
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'BridgetLily',
            fontSize: 28,
            color: titleColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: primaryColor,
                child: Icon(Icons.person, size: 48, color: titleColor),
              ),
              const SizedBox(height: 20),
              _buildInfoCard(Icons.person, "Name", name),
              _buildInfoCard(Icons.email, "Email", email),
              _buildInfoCard(Icons.phone, "Phone", phone),
              _buildInfoCard(Icons.location_on, "Address", address),
              const SizedBox(height: 30),
              _buildOrdersSection(),
              const SizedBox(height: 30),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: titleColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection() {
    if (userOrders.isEmpty) {
      return const Text("No orders found.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Orders",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 12),
        ...userOrders.map((order) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cake: ${order['cakeName']}", style: TextStyle(color: titleColor)),
                Text("Quantity: ${order['quantity']}"),
                Text("Total: \$${order['totalPrice']}"),
                Text("Delivery Date: ${order['deliveryDate']}"),
                Text("Status: ${order['status']}"),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _updateDeliveryDate(order['id'], pickedDate);
                      }
                    },
                    child: Text(
                      "Edit Delivery Date",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.logout),
      label: const Text("Logout"),
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: titleColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
