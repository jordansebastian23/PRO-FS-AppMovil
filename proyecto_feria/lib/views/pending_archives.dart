import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:proyecto_feria/services/upload_file.dart';

class PendingArchivesPage extends StatefulWidget {
  final Map<String, dynamic> archivo;

  const PendingArchivesPage({required this.archivo, Key? key}) : super(key: key);

  @override
  State<PendingArchivesPage> createState() => _PendingArchivesPageState();
}

class _PendingArchivesPageState extends State<PendingArchivesPage> {
  Future<void> _uploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        await UploadFile.uploadFile(
          file: file,
          tramiteId: widget.archivo['tramite_id'].toString(),
          tipoArchivoId: widget.archivo['tipo_archivo_id'].toString(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo subido exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error subiendo archivo: $e')),
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "No se seleccionó ningún archivo",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }

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
          title: Text(
            'Subir archivos',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListTile(
                  title: Text(
                    "Trámite ID: ${widget.archivo['tramite_id']}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 105, 148, 216),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tipo de Archivo: ${widget.archivo['tipo_archivo']}\n',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                              text: "Estado: ${widget.archivo['status'] == 'not_sent' ? 'No enviado' : widget.archivo['status'] == 'rejected' ? 'Rechazado' : widget.archivo['status']}\n",
                              style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                              ),
                            ),
                          // Test to check ArchivoTypeId
                          TextSpan(
                          text: 'ID de Tipo de Archivo: ${widget.archivo['tipo_archivo_id']}\n',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.archivo['feedback'] != null)
                          TextSpan(
                            text: "Feedback: ${widget.archivo['feedback']}\n",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(19.0),
        child: FloatingActionButton.extended(
          onPressed: () => _uploadFile(context),
          icon: Icon(Icons.upload_file_outlined),
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