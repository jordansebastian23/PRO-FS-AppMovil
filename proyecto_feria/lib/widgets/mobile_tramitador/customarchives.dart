import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/services/tramites_view.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';

class CustomWidgetArchives extends StatefulWidget {
  const CustomWidgetArchives({super.key});

  @override
  _CustomWidgetArchivesState createState() => _CustomWidgetArchivesState();
}

  class _CustomWidgetArchivesState extends State<CustomWidgetArchives> {
  Map<String, dynamic>? _lastTramite;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLastTramite();
  }

  Future<void> _fetchLastTramite() async {
    try {
      final tramites = await TramitesView.checkTramitesUser();
      if (tramites.isNotEmpty) {
        setState(() {
          _lastTramite = tramites.last;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching tramites: $e");
      setState(() {
        _isLoading = false;
      });
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
                    'Último Trámite',
                    style: GoogleFonts.libreFranklin(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  IconButton(
                    alignment: AlignmentDirectional.topEnd,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: const Color.fromARGB(255, 105, 148, 216),
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabbedHomePage(initialIndex: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              subtitle: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _lastTramite != null
                      ? CardMenuPrincipal(
                          title: 'Tipo de Trámite: ${_lastTramite!['tipo_tramite']}',
                          subtitle: 'Carga ID: ${_lastTramite!['carga_id']}\nEstado: ${_lastTramite!['estado']}',
                          image: 'assets/images/icono-historial.png',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TabbedHomePage(initialIndex: 2),
                              ),
                            );
                          },
                        )
                      : Text(
                          'No hay trámites disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}