import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/services/cargas_view.dart';
import 'package:proyecto_feria/services/tramites_view.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';

class CustomStatusProcedures extends StatefulWidget {
  const CustomStatusProcedures({Key? key}) : super(key: key);

  @override
  _CustomStatusProceduresState createState() => _CustomStatusProceduresState();
}

class _CustomStatusProceduresState extends State<CustomStatusProcedures> {
  Map<String, dynamic>? _latestTramite;
  Map<String, dynamic>? _latestCarga;

  @override
  void initState() {
    super.initState();
    _loadLatestTramiteAndCarga();
  }

  Future<void> _loadLatestTramiteAndCarga() async {
    try {
      // Fetch the latest tramite for the conductor
      final tramites = await TramitesView.getTramitesConductor();
      if (tramites.isNotEmpty) {
        setState(() {
          _latestTramite = tramites.last; // Assuming the last tramite is the latest
        });
      }

      // Fetch the latest carga for the user
      final cargas = await CargasView.getUserCargas();
      if (cargas.isNotEmpty) {
        setState(() {
          _latestCarga = cargas.last;
          print(_latestCarga);
        });
      }
    } catch (e) {
      print('Error fetching tramite or carga: $e');
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
                    'Estado de carga',
                    style: GoogleFonts.libreFranklin(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  if (_latestTramite != null && _latestCarga != null)
                    CardMenuPrincipal(
                      title: 'Estado: ${_latestTramite?['estado'] == 'pendiente' ? 'Pendiente' :  _latestTramite?['estado'] == 'pending' ? 'Pendiente' : _latestTramite?['estado'] == 'approved' ? 'Aprobado' : 'Retirado'}',
                      subtitle: "Carga ID: ${_latestCarga!['carga_id']}\n"
                          "Descripcion: ${_latestCarga!['descripcion']}",
                      image: 'assets/images/icono-historial.png',
                      onTap: () {
                        // Action for onTap if needed
                      },
                    )
                  else
                    Text(
                      'Cargando el último tramite y carga...',
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
