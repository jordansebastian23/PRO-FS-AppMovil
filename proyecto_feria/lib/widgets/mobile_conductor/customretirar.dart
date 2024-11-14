import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/cargas_list.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proyecto_feria/services/cargas_view.dart';
import 'package:proyecto_feria/services/constants.dart';

class CustomRetiroStatus extends StatefulWidget {
  const CustomRetiroStatus({Key? key}) : super(key: key);

  @override
  _CustomRetiroStatusState createState() => _CustomRetiroStatusState();
}

class _CustomRetiroStatusState extends State<CustomRetiroStatus> {
  LatLng? _latestCargaLocation;
  String? _latestCargaDescription;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadLatestCarga();
  }

  Future<void> _loadLatestCarga() async {
    final cargas = await CargasView.getUserCargas();
    if (cargas.isNotEmpty) {
      setState(() {
        final localizacion = cargas.last['localizacion'];
        if (localizacion != null && localizacion.contains(',')) {
          final coords = localizacion.split(',');
          final lat = double.tryParse(coords[0].trim());
          final lng = double.tryParse(coords[1].trim());

          if (lat != null && lng != null) {
            _latestCargaLocation = LatLng(lat, lng);
            _mapController.move(_latestCargaLocation!, 15); // Move map to latest carga location
            print(_latestCargaLocation);
          } else {
            print('Error: Unable to parse coordinates');
          }
        } else {
          print('Error: Invalid localizacion format');
        }
        _latestCargaDescription = cargas.last['descripcion'];
      });
    } else {
      print('No cargas found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 235, 237, 240),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Estado de Retiro',
              style: GoogleFonts.libreFranklin(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            IconButton(
              alignment: AlignmentDirectional.topEnd,
              icon: const Icon(
                Icons.list,
                color: Color.fromARGB(255, 105, 148, 216),
                size: 45,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CargasListPage()),
                );
              },
            ),
          ],
        ),
        subtitle: Column(
          children: [
            Text(
              _latestCargaDescription ?? 'Cargando la última carga...',
              style: GoogleFonts.libreFranklin(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 150,
              child: FlutterMap(
                mapController: _mapController, // Attach the controller
                options: MapOptions(
                  initialCenter: _latestCargaLocation ?? LatLng(-33.137854, -71.5582992),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: AppConstants.urlTemplate,
                    additionalOptions: {
                      'id': AppConstants.mapBoxStyleStreetsid,
                    },
                  ),
                  if (_latestCargaLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _latestCargaLocation!,
                          width: 80,
                          height: 80,
                          child: Icon(Icons.location_on, color: Colors.red, size: 50),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
