import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/inputs/custom_inputs.dart';
import 'package:proyecto_feria/ui/cards/custom_card_tabs.dart';
import 'package:proyecto_feria/ui/layouts/tabs/views/Init_procedures.dart';

class ProceduresPage extends StatefulWidget {
  const ProceduresPage({super.key});

  @override
  State<ProceduresPage> createState() => _ProceduresPageState();
}

class _ProceduresPageState extends State<ProceduresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20
          ),
          SizedBox(
            width: 300,
            height: 50,
            child: DropdownButtonFormField<String>(
              decoration: CustomImputs.dropDownItem(
                  colorBorder: Colors.black,
                  hint: 'Estado del tramite',
                  label: 'Estado del tramite'),
              items: ['Listo','Pendiente','Rechazado'].map((String ID) {
                return DropdownMenuItem<String>(
                  value: ID,
                  child: Text(ID),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
          CustomCardTabs(
            title: 'Tramite N° 1337',
            subtitle: 'Carga número: 1337',
            description:
                'Tipo de carga: Full\nDestinatario: Jordan Navarrete\nFecha de tramitacion: 12/12/2021',
            trailing: 'Ver mas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InitProceduresPage()),
              );
            },
          ),
          CustomCardTabs(
            title: 'Tramite N° 1337',
            subtitle: 'Carga número: 1337',
            description:
                'Tipo de carga: Full\nDestinatario: Jordan Navarrete\nFecha de tramitacion: 12/12/2021',
            trailing: 'Ver mas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InitProceduresPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(19.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InitProceduresPage()),
            );
          },
          label: Text(
            'Iniciar nuevo tramite',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 100, 209, 203),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          heroTag: 'uniqueHeroTag',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
