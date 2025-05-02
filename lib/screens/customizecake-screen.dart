import 'package:flutter/material.dart';

class CustomizeCakePage extends StatefulWidget {
  @override
  _CustomizeCakePageState createState() => _CustomizeCakePageState();
}

class _CustomizeCakePageState extends State<CustomizeCakePage> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedShape = '';
  String _selectedFlavor = '';
  String _selectedFrosting = '';
  String _selectedToppings = '';
  bool _isConfirmed = false;

  void _showConfirmationDialog() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Confirm Your Cake', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shape: $_selectedShape'),
                Text('Flavor: $_selectedFlavor'),
                Text('Frosting: $_selectedFrosting'),
                Text('Toppings: $_selectedToppings'),
                SizedBox(height: 10),
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_descriptionController.text),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() => _isConfirmed = true);
                  Navigator.of(context).pop();
                },
                child: Text('Confirm', style: TextStyle(color: Color(0xFF725841))),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  void _sendMessageToBaker() {
    print('Message sent to baker:');
    print('Shape: $_selectedShape');
    print('Flavor: $_selectedFlavor');
    print('Frosting: $_selectedFrosting');
    print('Toppings: $_selectedToppings');
    print('Description: ${_descriptionController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Message sent to the baker!")),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? currentValue,
    required List<String> options,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF725841),
          ),
        ),
        SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.pink[50],
          ),
          hint: Text('Select $label'),
          items: options
              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Customize Your Cake',
          style: TextStyle(
            color: Color(0xFF725841),
            fontFamily: 'BridgetLily',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromRGBO(251, 221, 210, 1),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF725841)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDropdown(
                  label: 'Shape',
                  currentValue: _selectedShape.isEmpty ? null : _selectedShape,
                  options: ['Round', 'Square', 'Heart', 'Other'],
                  onChanged: (val) => setState(() => _selectedShape = val!),
                  validator: (val) => val == null ? 'Please select a shape' : null,
                ),
                _buildDropdown(
                  label: 'Flavor',
                  currentValue: _selectedFlavor.isEmpty ? null : _selectedFlavor,
                  options: ['Chocolate', 'Vanilla', 'Strawberry', 'Other'],
                  onChanged: (val) => setState(() => _selectedFlavor = val!),
                  validator: (val) => val == null ? 'Please select a flavor' : null,
                ),
                _buildDropdown(
                  label: 'Frosting',
                  currentValue: _selectedFrosting.isEmpty ? null : _selectedFrosting,
                  options: ['Buttercream', 'Whipped Cream', 'Fondant', 'Other'],
                  onChanged: (val) => setState(() => _selectedFrosting = val!),
                  validator: (val) => val == null ? 'Please select frosting' : null,
                ),
                _buildDropdown(
                  label: 'Toppings',
                  currentValue: _selectedToppings.isEmpty ? null : _selectedToppings,
                  options: ['Chocolate Chips', 'Strawberries', 'Nuts', 'Other'],
                  onChanged: (val) => setState(() => _selectedToppings = val!),
                  validator: (val) => val == null ? 'Please select toppings' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Cake Description',
                    hintText: 'Describe your dream cake...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.pink[50],
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Please enter a description' : null,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  child: Text(
                    'Review & Confirm',
                    style: TextStyle(color: Color(0xFF725841)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(251, 221, 210, 1),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                if (_isConfirmed) ...[
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _sendMessageToBaker,
                    child: Text(
                      'Send to Baker',
                      style: TextStyle(color: Color(0xFF725841)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(251, 221, 210, 1),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
