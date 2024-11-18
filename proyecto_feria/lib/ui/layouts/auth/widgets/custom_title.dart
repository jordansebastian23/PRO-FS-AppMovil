import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/constants/colors.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
                  text: TextSpan(
                    text: 'Logi', style: GoogleFonts.montserratAlternates(
                    fontSize: 50,
                    color: CustomColor.buttons,
                    fontWeight: FontWeight.bold
                  ),
                  children: [TextSpan(
                    text: 'Quick', style: GoogleFonts.montserratAlternates(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )
                  )
                  
            ]
                ),
                
              ),

              CircleAvatar(
                      radius: 122,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/images/logiquick.png', width: 450 )),
      ],
    );
  }
}