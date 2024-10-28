import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormCodeOtp extends StatelessWidget {
  const FormCodeOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                  width: 57,
                  height: 60,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0), // Borde cuadrado
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0), // Borde cuadrado
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0), // Borde cuadrado
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                );
  }
}