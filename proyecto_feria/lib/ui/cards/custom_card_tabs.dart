import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/views/pending_payment.dart';

class CustomCardTabs extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String trailing;
  final Function onPressed;

  const CustomCardTabs(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.description,
      required this.trailing,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 0, 0, 0),
                width: 2,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(25)),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                  color: Color.fromARGB(255, 105, 148, 216),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(TextSpan(children: [
              TextSpan(
                text: subtitle + '\n',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: description,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                ),
              ),
            ])),
            trailing: IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 100, 209, 203)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              icon: Text(
                trailing,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                onPressed();
              },
            ),
          )),
    );
  }
}
