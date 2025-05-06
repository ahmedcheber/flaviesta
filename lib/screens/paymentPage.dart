import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage-screen.dart'; // Import the HomePage

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> itemData;

  const PaymentPage({super.key, required this.itemData});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _deliveryDateController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  void submitPayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        final orderData = {
          'cakeName': widget.itemData['cakeName'],
          'image': widget.itemData['image'],
          'quantity': widget.itemData['quantity'],
          'totalPrice': widget.itemData['totalPrice'],
          'orderTime': Timestamp.now(),
          'status': 'Processing',
          'deliveryDate': _deliveryDateController.text.trim(),
          'paymentInfo': {
            'cardNumber': _cardNumberController.text.trim(),
            'expiry': _expiryDateController.text.trim(),
            'cvv': _cvvController.text.trim(),
          },
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('orders')
            .add(orderData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order confirmed!')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            fontFamily: 'BridgetLily',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 114, 88, 65),
          ),
        ),
        backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Cake: ${widget.itemData['cakeName']}'),
                      Text('Quantity: ${widget.itemData['quantity']}'),
                      Text('Total: \$${widget.itemData['totalPrice'].toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  CardNumberInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty || value.replaceAll(' ', '').length < 16) {
                    return 'Enter a valid card number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                  ExpiryDateInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter expiry date.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.length != 3) {
                    return 'Enter a valid 3-digit CVV.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deliveryDateController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Date (dd/mm/yy)',
                  prefixIcon: Icon(Icons.delivery_dining),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                  ExpiryDateInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || !RegExp(r'^\d{2}/\d{2}/\d{2}$').hasMatch(value)) {
                    return 'Enter date in dd/mm/yy format.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: submitPayment,
                icon: const Icon(Icons.payment),
                label: const Text('Submit Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(251, 221, 210, 1),
                  foregroundColor: const Color.fromARGB(255, 160, 138, 108),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ➕ Formatteur pour carte bancaire
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// ➕ Formatteur pour date (MM/YY ou DD/MM/YY)
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i + 1 != text.length) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
