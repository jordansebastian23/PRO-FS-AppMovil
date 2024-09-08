import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/screen/home.dart';

class CustomWidgetProcedures extends StatelessWidget {
  const CustomWidgetProcedures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Card(
          elevation: 5,
          color: Color.fromARGB(255, 235, 237, 240),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Archivos pendientes',
                  style: GoogleFonts.libreFranklin(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                IconButton(
                  alignment: AlignmentDirectional.topEnd,
                  icon: Icon(Icons.more_horiz,
                  color: const Color.fromARGB(255, 105,148,216),
                  size: 45,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    );
  
                  },
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 39, 46, 75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: ClipRect(
                      child: Image.asset(
                        'assets/images/icono-archivos.png',
                        height: 64,
                        width: 66,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(
                      "Guia de despacho",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Carga número: 1337",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                          ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}