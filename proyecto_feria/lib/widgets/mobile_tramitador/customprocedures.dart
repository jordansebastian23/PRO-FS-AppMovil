import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/services/archives_view.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';

class CustomWidgetProcedures extends StatefulWidget {
  const CustomWidgetProcedures({super.key});

  @override
  _CustomWidgetProceduresState createState() => _CustomWidgetProceduresState();
}

  class _CustomWidgetProceduresState extends State<CustomWidgetProcedures> {
  int _pendingFilesCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingFiles();
  }

  Future<void> _fetchPendingFiles() async {
    try {
      final archivos = await ArchivesView.getUserAssignedFiles();
      setState(() {
        _pendingFilesCount = archivos.length;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching pending files: $e");
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
                    'Archivos Pendientes',
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
                          builder: (context) => TabbedHomePage(initialIndex: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              subtitle: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      _pendingFilesCount > 0
                          ? 'Tienes $_pendingFilesCount archivos pendientes'
                          : 'No hay archivos pendientes',
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
