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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      // height: screenHeight * 0.4,
      decoration: BoxDecoration(
        // color: AppColors.backgroundColor,
      ),
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade100.withOpacity(0.8), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  location,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
