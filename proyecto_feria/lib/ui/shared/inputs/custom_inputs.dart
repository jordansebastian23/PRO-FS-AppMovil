import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/shared/colors.dart';

class CustomImputs {
  static InputDecoration loginInput(
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


  static InputDecoration dropDownItem({
    required String hint,
    required String label,
    Color colorBorder = Colors.white,
  }){
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorBorder)
      ),
      enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorBorder)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: CustomColor.buttons)
      ),
      hintText: hint,
      labelText: label,
      labelStyle: TextStyle( color: Colors.grey ),
      hintStyle: TextStyle( color: Colors.grey ),
    );
  }
}


