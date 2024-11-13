import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';

class CustomWidgetArchives extends StatelessWidget {
  const CustomWidgetArchives({super.key});

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
                  'Historial de tramites',
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
                    //Accion ir a la pagina homepage -> paymentspage
                    Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabbedHomePage(), // Índice de la pestaña de pagos
              ),
            );
                    

                  },
                ),
              ],
            ),
            subtitle: Column(
              children: [
                CardMenuPrincipal(
                  title: 'Tramite N°1',
                  subtitle: 'Carga numero: 123\nFecha: 12/12/2021',
                  image: 'assets/images/icono-historial.png', onTap: () {  },
                ),
                
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
