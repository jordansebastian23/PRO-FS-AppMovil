import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/services/tab_control.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/widgets/custom_card.dart';

class CardAssignedLoad extends StatelessWidget {
  const CardAssignedLoad({super.key});

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
                  'Carga Asignada',
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
                CustomCardDashboard(
                  title: 'Carga N°1',
                  subtitle: 'Destinatario: empresa 3\nTipo de carga: full',
                  image: 'assets/images/icono-historial.png',
                ),
                
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
