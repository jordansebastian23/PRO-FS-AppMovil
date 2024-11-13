import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:proyecto_feria/services/upload_file.dart';

class PendingArchivesPage extends StatefulWidget {
  const PendingArchivesPage({super.key});

  @override
  State<PendingArchivesPage> createState() => _PendingArchivesPageState();
}

class _PendingArchivesPageState extends State<PendingArchivesPage> {
  Map<String, Map<String, dynamic>> files = {
    'Factura.pdf.': {'checked': false, 'size': '2 MB'},
    'GuíaDeDespacho.pdf': {'checked': false, 'size': '1.5 MB'},
    'CertificadoDeOrigen.pdf': {'checked': false, 'size': '3 MB'},
    'ManifiestoDeCarga.pdf': {'checked': false, 'size': '2.5 MB'},
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(118),
        child: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          toolbarHeight: 120.0,
          title: Text('Subir archivos',
          textAlign: TextAlign.center,
            style: GoogleFonts.libreFranklin(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 39, 46, 75),
        ),
      ),
      body: Column(
        children: [
          Card(
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
                title: Text("Carga n° 985",
                style: TextStyle(color:Color.fromARGB(255, 105, 148, 216),
                fontSize: 22,
                fontWeight: FontWeight.bold),
                ),
                subtitle: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Tipo de carga: Full\n',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "Archivos faltantes: Factura / Guía de despacho.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ])),
            
                )
              ),
            ),

            Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: files.keys.map((String key) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: files[key]!['checked'],
                            onChanged: (bool? value) {
                              setState(() {
                                files[key]!['checked'] = value!;
                              });
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(255, 112, 150, 209),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.upload_file_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                key,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                files[key]!['size'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),

      floatingActionButton: Padding(
  padding: const EdgeInsets.all(19.0),
  child: FloatingActionButton.extended(
    onPressed: () async {
      // Acción al presionar el botón
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        // TODO: Update this
        // await uploadFile(file);
      } else {
        // Acción si el usuario cancela la selección de archivos
        print('No se seleccionó ningún archivo');
        Fluttertoast.showToast(
          msg: "No se seleccionó ningún archivo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      }
    },
    icon: Icon(Icons.upload_file_outlined), // Icono del botón flotante
    label: Text(
      'Subir Archivos',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Color.fromARGB(255, 100, 209, 203),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


    );
  }
}