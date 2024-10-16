import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';

class CustomWidgetPayment extends StatelessWidget {
  const CustomWidgetPayment({super.key});

  //Colores
  //Color container: Color.fromARGB(255,235,237,240),
  //Color Divider: 6994D8
  //Color Texto: black

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
                  'Pagos pendientes',
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
                  title: 'Pago #1',
                  subtitle: 'Carga numero: 123\nA pagar: \$100.000',
                  image: 'assets/images/icono-pagos.png',
                ),
                SizedBox(height: 10),
                CardMenuPrincipal(
                  title: 'Pago #1',
                  subtitle: 'Carga numero: 123\nA pagar: \$100.000',
                  image: 'assets/images/icono-pagos.png',
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
