import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/widgets/customarchives.dart';
import 'package:proyecto_feria/widgets/custompayment.dart';
import 'package:proyecto_feria/widgets/customprocedures.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(118),
        child: AppBar(
          toolbarHeight: 120.0,
          //centerTitle: true,
          title: 
          Text(
            'Bienvenido! \$usuario',
            textAlign: TextAlign.start,
            style: GoogleFonts.libreFranklin(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 39, 46, 75),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/Avatar.png'),
                radius: 36,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomWidgetPayment(),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Color.fromARGB(255, 105,148,216),
              endIndent: 125,
              indent: 125,
              thickness: 3,
            ),
            SizedBox(
              height: 15,
            ),
            CustomWidgetProcedures(),
            SizedBox(
              height: 15,
            ),
            CustomWidgetArchives(),
          ],
        )
      ),
    );
  }
}