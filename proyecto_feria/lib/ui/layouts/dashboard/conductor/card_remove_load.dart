import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/services/tab_control.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proyecto_feria/constants/constants.dart';

class CardRemoveLoad extends StatelessWidget {
  const CardRemoveLoad({super.key});

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
                    'Estado de Retiro',
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
                      // Acción para ir a la página principal -> pestaña de retiros
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabbedHomePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150, // Ajusta la altura según tus necesidades
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(-33.137854,-71.5582992),
                        minZoom: 30,
                        maxZoom: 50,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: AppConstants.urlTemplate,
                          additionalOptions: {
                            'id': AppConstants.mapBoxStyleStreetsid,
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: (){
                        // Acción para copiar las coordenadas
                        print('Coordenadas copiadas');
                      },
                      child: Text('Copiar Coordenadas')),
                      TextButton(onPressed: (){
                        // Acción para ir a la página principal -> pestaña de retiros
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Maps_view(),
                          ),
                        );
                      },
                      child: Text('Ver Mapa'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Maps_view extends StatefulWidget {
  const Maps_view
({super.key});

  @override
  State<Maps_view> createState() => _Maps_viewState();
}

class _Maps_viewState extends State<Maps_view> {

    final MapController _mapController = MapController();
  double _currentZoom = 15.0;
  
  final center = LatLng(-33.137854, -71.5582992);
  void _zoomIn() {
    setState(() {
      _currentZoom++;
      _mapController.move(center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom--;
      _mapController.move(center, _currentZoom);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text('Mapa de Retiro',
          style: GoogleFonts.libreFranklin(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 26,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 39, 46, 75),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:  LatLng(-33.137854, -71.5582992),
              minZoom: _currentZoom,
              maxZoom: 50
            ),
            children: [
              TileLayer(
                urlTemplate: AppConstants.urlTemplate,
                additionalOptions: {
                  'id': AppConstants.mapBoxStyleStreetsid,
                },
              ),
              MarkerLayer(markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(-33.137854, -71.5582992),
                  child: Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ),
              ]),
            ],
          ),
          Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FloatingActionButton(
                        onPressed: _zoomIn,
                        child: Icon(Icons.zoom_in),
                        mini: true,
                      ),
                      SizedBox(width: 10),
                      FloatingActionButton(
                        onPressed: _zoomOut,
                        child: Icon(Icons.zoom_out),
                        mini: true,
                      ),

              ],
            ),
        ],
      ),
    );
  }
}
