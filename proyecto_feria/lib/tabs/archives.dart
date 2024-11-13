import 'package:flutter/material.dart';
import 'package:proyecto_feria/services/archives_view.dart';
import 'package:proyecto_feria/views/pending_archives.dart';

class ArchivesPage extends StatefulWidget {
  const ArchivesPage({Key? key}) : super(key: key);

  @override
  _ArchivesPageState createState() => _ArchivesPageState();
}

class _ArchivesPageState extends State<ArchivesPage> {
  List<dynamic> _archivos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArchivos();
  }

  Future<void> _fetchArchivos() async {
    try {
      final archivos = await ArchivesView.getUserAssignedFiles();
      setState(() {
        _archivos = archivos;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching archivos: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _archivos.length,
              itemBuilder: (context, index) {
                final archivo = _archivos[index];
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
                        "Archivo requerido: ${archivo['tipo_archivo']}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 105, 148, 216),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'ID Trámite: ${archivo['tramite_id']}\n',
                              style: TextStyle(
                                color: Color.fromARGB(255, 32, 12, 12),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Estado: ${archivo['status'] == 'not_sent' ? 'No enviado' : archivo['status'] == 'rejected' ? 'Rechazado' : archivo['status']}\n",
                              style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                              ),
                            ),
                            if (archivo['feedback'] != null)
                              TextSpan(
                                text: "Feedback: ${archivo['feedback']}\n",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 15,
                                ),
                              ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.upload_file),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PendingArchivesPage(archivo: archivo),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}