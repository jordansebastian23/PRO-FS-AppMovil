import 'package:flutter/material.dart';

class LinkText extends StatefulWidget {
  final String text;
  final Function? onPressed;

  const LinkText({super.key,
  required this.text,
  this.onPressed});

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.onPressed != null) widget.onPressed!();
      },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(widget.text,
          style: TextStyle(
            color: Color(0xFF64D1CB),
            fontSize: 16,
            decoration: TextDecoration.underline,
          )),
          
        ),
    );
  }
}