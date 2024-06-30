import 'dart:async';
import 'package:flutter/material.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({Key? key}) : super(key: key);

  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  Offset position = Offset(300, 700);
  int? selectedDriverIndex;
  Timer? _timer;
  int _seconds = 45;

  final List<Map<String, dynamic>> drivers = const [
    {'name': 'Driver 1', 'rating': 4.7, 'price': 147, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 2', 'rating': 4.2, 'price': 125, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 3', 'rating': 4.9, 'price': 177, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 4', 'rating': 3.8, 'price': 103, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 5', 'rating': 4.9, 'price': 169, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 6', 'rating': 4.0, 'price': 120, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 8', 'rating': 4.1, 'price': 132, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 9', 'rating': 3.5, 'price': 110, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 10', 'rating': 4.3, 'price': 145, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 11', 'rating': 4.6, 'price': 160, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 12', 'rating': 4.4, 'price': 138, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 13', 'rating': 4.7, 'price': 155, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 14', 'rating': 3.9, 'price': 128, 'image': 'assets/images/user2.png'},
    {'name': 'Driver 15', 'rating': 4.8, 'price': 170, 'image': 'assets/images/user2.png'},
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/auto.png',
                          height: 40,
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '25-30 Rs/km',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Your Bid',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '₹123',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text('Sort by: '),
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    SizedBox(width: 4),
                    Text('Ratings'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDriverIndex = index;
                        });
                        Navigator.pushNamed(
                          context,
                          '/rideconfirmation',
                          arguments: driver,
                        );
                      },
                      child: Container(
                        color: selectedDriverIndex == index ? Colors.green.withOpacity(0.5) : Colors.transparent,
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                backgroundImage: AssetImage(driver['image']),
                              ),
                              title: Text(driver['name']),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow, size: 16),
                                  SizedBox(width: 4),
                                  Text(driver['rating'].toString()),
                                ],
                              ),
                              trailing: Text('₹${driver['price']}'),
                            ),
                            if (index < drivers.length - 1)
                              Divider(
                                thickness: 2,
                                color: Colors.grey[300],
                                indent: 10,
                                endIndent: 16,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              feedback: timerWidget(),
              child: timerWidget(),
              childWhenDragging: Container(),
              onDragEnd: (dragDetails) {
                setState(() {
                  position = dragDetails.offset;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget timerWidget() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        '00:${_seconds.toString().padLeft(2, '0')}',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
