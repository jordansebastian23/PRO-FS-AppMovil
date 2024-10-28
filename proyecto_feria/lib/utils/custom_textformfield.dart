import 'package:flutter/material.dart';

class CustomImputs {
  static InputDecoration loginInputStyle(
      {String? hint,  String?label, IconData? icon}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      hintText: hint,
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: Colors.grey),
    );
  }
}


class CustomOutlinedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final bool isFilled;
  final Color textColor;

  const CustomOutlinedButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.textColor,
      this.color = Colors.white,
      this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: color),
          ),
          backgroundColor: WidgetStatePropertyAll(
            isFilled ? color : Colors.transparent,
          )

        ),
        onPressed: () => onPressed(),
      
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: textColor),
          ),
        ));
  }
}