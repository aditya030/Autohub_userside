import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyNumberController = TextEditingController();
  
  bool _isEditMode = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emergencyNumberController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        setState(() {
          _isEditMode = true;
          _fullNameController.text = doc['first_name'];
          _lastNameController.text = doc['last_name'];
          _phoneNumberController.text = doc['phone_number'];
          _addressController.text = doc['address'];
          _emergencyNumberController.text = doc['emergency_number'];
        });
      }
    }
  }

  Future<void> _saveUserDetails() async {
    if (_formKey.currentState!.validate()) {
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'first_name': _fullNameController.text,
          'last_name': _lastNameController.text,
          'phone_number': _phoneNumberController.text,
          'address': _addressController.text,
          'emergency_number': _emergencyNumberController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User details saved')));
        Navigator.pushNamed(context, '/homepage');
      }
    }
  }

  Future<void> _updateUserDetails() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'first_name': _fullNameController.text,
        'last_name': _lastNameController.text,
        'phone_number': _phoneNumberController.text,
        'address': _addressController.text,
        'emergency_number': _emergencyNumberController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User details updated')));
      Navigator.pushNamed(context, '/homepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/user2.png'),
                ),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    // Handle edit profile image
                  },
                  child: Text(
                    'Edit profile image',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 16.0),
                UserInfoField(label: 'First Name', controller: _fullNameController),
                UserInfoField(label: 'Last Name', controller: _lastNameController),
                UserInfoField(label: 'Phone Number', controller: _phoneNumberController),
                UserInfoField(label: 'Address', controller: _addressController),
                UserInfoField(label: 'Emergency Number', controller: _emergencyNumberController),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isEditMode ? _updateUserDetails : _saveUserDetails,
                  child: Text(_isEditMode ? 'Update Details' : 'Save Details'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
        ],
      ),
    );
  }
}

class UserInfoField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  UserInfoField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 4.0),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

