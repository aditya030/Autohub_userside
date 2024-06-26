import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RideScreen extends StatelessWidget {
  final LatLng _center = LatLng(12.9715987, 79.1595439); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                12.9692,
                79.1559,
              ),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.vit.vellore',
              ),

              // Dynamically fetch the users current location
              // According the latitude and the longitude will be set.
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      12.9692,
                      79.1559,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.green),
                      title: Text('Vit Main Gate'),
                    ),
                    ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.red),
                      title: Text('Katpadi railway station'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your ride',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text('Auto'),
                    subtitle: Text('2-3 person'),
                    trailing: Text('₹ 120'),
                  ),
                  ListTile(
                    tileColor: Colors.greenAccent,
                    title: Text('Premium Auto'),
                    subtitle: Text('4-5 person'),
                    trailing: Text('₹ 150'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.money),
                          label: Text('Cash'),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.discount),
                          label: Text('Promo code'),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/feedback');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Book this auto'),
                        Text('₹ 150'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
