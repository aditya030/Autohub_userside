import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              UserInfoField(label: 'Name', initialValue: 'Raaj'),
              UserInfoField(label: 'Username', initialValue: '@username'),
              UserInfoField(label: 'Email', initialValue: 'name@vit.ac.in'),
              UserInfoField(label: 'Payment Methods', initialValue: 'name@okxyzbank'),
              UserInfoField(label: '', initialValue: '2548 4596 5365 4126'),
              UserInfoField(label: '', initialValue: 'Credit bank'),
              TextButton(
                onPressed: () {
                  // Handle add method
                },
                child: Text(
                  '+ Add Method',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              UserInfoField(label: 'Bio', initialValue: 'A description of this user.'),
            ],
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
  final String initialValue;

  UserInfoField({required this.label, required this.initialValue});

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
            initialValue: initialValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
