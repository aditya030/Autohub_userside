import 'package:autohub_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'const.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), border: Border.symmetric()),
      child: Column(
        children: [
          ListTile(
            onTap: press,
            horizontalTitleGap: 0,
            leading: const Icon(
              Icons.location_on,
              color: Colors.green,
            ),
            title: Text(
              location,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
