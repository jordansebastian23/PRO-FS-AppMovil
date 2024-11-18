import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/layouts/tabs/widgets/custom_card_payments.dart';
import 'package:proyecto_feria/ui/views/pending_archives.dart';
class ArchivesPage extends StatelessWidget {
  const ArchivesPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomCardTabs(
            title: 'Archivos pendientes',
            subtitle: 'Carga número: 1337\nA pagar: \$120.000',
            description: 'Archivos pendientes: 3\nTipo de archivo: Factura y Guía de despacho.',
            trailing: 'Abrir',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PendingArchivesPage()),
              );
            },
          ),
          CustomCardTabs(
            title: 'Archivos pendientes',
            subtitle: 'Carga número: 1337\nA pagar: \$120.000',
            description: 'Archivos pendientes: 3\nTipo de archivo: Factura y Guía de despacho.',
            trailing: 'Abrir',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PendingArchivesPage()),
              );
            },
          ),
          
        ],
      ),
      
    );
  }
}