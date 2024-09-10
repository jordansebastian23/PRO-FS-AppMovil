import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingArchivesPage extends StatelessWidget {
  const PendingArchivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(118),
        child: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          toolbarHeight: 120.0,
          title: Text('Subir archivos',
          textAlign: TextAlign.center,
            style: GoogleFonts.libreFranklin(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 39, 46, 75),
        ),
      ),

    );
  }
}