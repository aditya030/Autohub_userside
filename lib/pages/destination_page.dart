import 'package:flutter/material.dart';

class DestinationPage extends StatelessWidget {
  final List<Location> locations = [
    Location('Chennai International Airport', 'Airport Rd, Meenambakkam, Chennai, Tamil Na..'),
    Location('Airport Departures Terminal Link', 'Meenambakkam, Chennai, Tamil Nadu'),
    Location('The Park Chennai', '601, Anna Salai, near US Embassy, Gangal Karai..'),
    Location('Chennai domestic airport', 'X5M7+2HV, Airport Departures Terminal Link, M..'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox.shrink(),
        elevation: 0,
      ), // AppBar
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Icon(Icons.search),
                    ),
                    hintText: 'From',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ), // TextField From
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Icon(Icons.search),
                    ),
                    hintText: 'To',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ), // TextField To
              ],
            ),
          ), // Padding
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/map_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ), // Container
            ],
          ), // Stack
          Expanded(
            child: ListView.builder(
              itemCount: locations.length + 2,
              itemBuilder: (context, index) {
                if (index < locations.length) {
                  return ListTile(
                    leading: Icon(Icons.location_on, size: 28),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(locations[index].name),
                    ),
                    subtitle: Text(locations[index].address),
                  ); // ListTile for locations
                } else if (index == locations.length) {
                  return ListTile(
                    leading: Icon(Icons.search, size: 28),
                    title: Text('Search for A'),
                  ); // ListTile for Search for A
                } else {
                  return ListTile(
                    leading: Icon(Icons.map, size: 28),
                    title: Text('Set location on map'),
                  ); // ListTile for Set location on map
                }
              },
            ),
          ), // Expanded
        ],
      ), // Column (body)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.green,
        onTap: (index) {
          // Handle bottom navigation tab change if needed
        },
      ), // BottomNavigationBar
    ); // Scaffold
  }
}

class Location {
  final String name;
  final String address;

  Location(this.name, this.address);
}