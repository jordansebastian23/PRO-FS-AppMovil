import 'package:flutter/material.dart';
import 'package:proyecto_feria/views/pending_archives.dart';
class ArchivesPage extends StatelessWidget {
  const ArchivesPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Card(
        margin: EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(25)
          ),
          child: ListTile(
            title: Text("Archivos pendientes",
            style: TextStyle(color:Color.fromARGB(255, 105, 148, 216),
            fontSize: 20,
            fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(TextSpan(children: [
              TextSpan(
                text: 'Carga número: 1337\n',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "A pagar: \$120.000\n",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: "Archivos pendientes: 3\n",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: "Tipo de archivo: Factura y Guía de despacho.",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                ),
              )
            ])),
          trailing: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 100, 209, 203)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            icon: Text('Abrir',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            ),            
            onPressed: () { 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PendingArchivesPage()),
              );
            },
            ),
            )
          ),
        ),
      
    );
  }
}