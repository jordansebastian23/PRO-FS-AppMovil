import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:proyecto_feria/services/constants.dart';

class MapView extends StatelessWidget {
  final LatLng location;
  final String description;

  const MapView({required this.location, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$description',
          style: GoogleFonts.libreFranklin(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 39, 46, 75),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: location,
          initialZoom: 15,
        ),
        children: [
          TileLayer(urlTemplate: AppConstants.urlTemplate, additionalOptions: {
                            'id': AppConstants.mapBoxStyleStreetsid,
                          },),
          MarkerLayer(
            markers: [
              Marker(
                point: location,
                child: Icon(Icons.location_on, color: Colors.red, size: 50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
