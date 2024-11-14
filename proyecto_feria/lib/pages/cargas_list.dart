import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/map_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:proyecto_feria/services/cargas_view.dart';
import 'package:intl/intl.dart';

class CargasListPage extends StatefulWidget {
  @override
  _CargasListPageState createState() => _CargasListPageState();
}

class _CargasListPageState extends State<CargasListPage> {
  List<dynamic> _cargas = [];

  @override
  void initState() {
    super.initState();
    _fetchCargas();
  }

  Future<void> _fetchCargas() async {
    final cargas = await CargasView.getUserCargas();
    setState(() {
      _cargas = cargas;
    });
  }

  LatLng? _getLatLngFromLocalizacion(String? localizacion) {
    if (localizacion != null && localizacion.contains(',')) {
      final coords = localizacion.split(',');
      final lat = double.tryParse(coords[0].trim());
      final lng = double.tryParse(coords[1].trim());
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Cargas',
          style: GoogleFonts.libreFranklin(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 39, 46, 75),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _cargas.length,
        itemBuilder: (context, index) {
          final carga = _cargas[index];
          final location = _getLatLngFromLocalizacion(carga['localizacion']);

          return Card(
            margin: EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 0, 0, 0),
                  width: 2,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListTile(
                title: Text(
                  "Carga: ${carga['descripcion']}",
                  style: TextStyle(
                    color: Color.fromARGB(255, 105, 148, 216),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado: ${carga['estado'] == 'pendiente' ? 'Pendiente' :  carga['estado'] == 'pending' ? 'Pendiente' : carga['estado'] == 'approved' ? 'Aprobado' : 'Retirado'}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                      ),
                    ),
                    if (carga['fecha_retiro'] != null)
                      Text(
                        "Fecha de Retiro: ${carga['fecha_retiro'] != null ? DateFormat('dd/MM/yy HH:mm:ss').format(DateTime.parse(carga['fecha_retiro'])) : 'N/A'}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 12, 12),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (carga['localizacion'] != null)
                      Text(
                        "Localización: ${carga['localizacion']}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 12, 12),
                          fontSize: 15,
                        ),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.map),
                  onPressed: location != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapView(
                                location: location,
                                description: carga['descripcion'],
                              ),
                            ),
                          );
                        }
                      : null, // Disable button if location is null
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
