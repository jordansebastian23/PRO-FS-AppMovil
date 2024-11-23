import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/services/tramites_view.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';

class CustomStatusProcedures extends StatefulWidget {
  const CustomStatusProcedures({Key? key}) : super(key: key);

  @override
  _CustomStatusProceduresState createState() => _CustomStatusProceduresState();
}

class _CustomStatusProceduresState extends State<CustomStatusProcedures> {
  Map<String, dynamic>? _latestTramite;

  @override
  void initState() {
    super.initState();
    _loadLatestTramite();
  }

  Future<void> _loadLatestTramite() async {
    try {
      final tramites = await TramitesView.getTramitesConductor();
      if (tramites.isNotEmpty) {
        setState(() {
          _latestTramite = tramites.last; // Assuming the last tramite is the latest
          print('Latest tramite: $_latestTramite');
        });
      }
    } catch (e) {
      print('Error fetching tramites: $e');
    }
  }

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
                    'Estado de trámite',
                    style: GoogleFonts.libreFranklin(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  // IconButton(
                  //   alignment: AlignmentDirectional.topEnd,
                  //   icon: Icon(
                  //     Icons.more_horiz,
                  //     color: const Color.fromARGB(255, 105, 148, 216),
                  //     size: 45,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => TabbedHomePage(),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
              subtitle: Column(
                children: [
                  if (_latestTramite != null)
                    CardMenuPrincipal(
                      title: 'Estado: ${_latestTramite?['estado'] == 'pendiente' ? 'Pendiente' :  _latestTramite?['estado'] == 'pending' ? 'Pendiente' : _latestTramite?['estado'] == 'approved' ? 'Aprobado' : 'Retirado'}',
                      subtitle: "Carga ID: ${_latestTramite!['carga_id']}\n"
                          "Tramite Tipo: ${_latestTramite!['tramite_type'] ?? 'Desconocido'}",
                      image: 'assets/images/icono-historial.png',
                      onTap: () {
                        // Action for onTap if needed
                      },
                    )
                  else
                    Text(
                      'Cargando la última carga...',
                      style: GoogleFonts.libreFranklin(fontSize: 20),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
