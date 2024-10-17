import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';

class CustomRetirar extends StatelessWidget {
  const CustomRetirar({super.key});

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
                  'Ruta a retiro de carga',
                  style: GoogleFonts.libreFranklin(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                IconButton(
                  alignment: AlignmentDirectional.topEnd,
                  icon: Icon(
                    Icons.more_horiz,
                    color: const Color.fromARGB(255, 105, 148, 216),
                    size: 45,
                  ),
                  onPressed: () {
                    //Accion ir a la pagina homepage -> paymentspage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TabbedHomePage(), // Índice de la pestaña de pagos
                      ),
                    );
                  },
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Container(
                  width: 343,
                  height: 150,
                  //maps
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/contenedor.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text('Copiar Coordenadas',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold))),
                    TextButton(
                        onPressed: () {},
                        child: Text('Ir a Google Maps',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                fontWeight: FontWeight.bold))),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
