import 'package:flutter/material.dart';


class CustomCardDashboard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const CustomCardDashboard(
      {super.key,
      required this.title,
      this.subtitle = '',
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 39, 46, 75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: ClipRect(
          child: Image.asset(
            image,
            height: 64,
            width: 66,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: subtitle,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
