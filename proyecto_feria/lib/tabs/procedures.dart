import 'package:flutter/material.dart';
import 'package:proyecto_feria/services/tramites_view.dart';

class ProceduresPage extends StatefulWidget {
  const ProceduresPage({super.key});

  @override
  State<ProceduresPage> createState() => _ProceduresPageState();
}

class _ProceduresPageState extends State<ProceduresPage> {
  List<dynamic> _tramites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTramites();
  }

  Future<void> _fetchTramites() async {
    try {
      final tramites = await TramitesView.checkTramitesUser();
      setState(() {
        _tramites = tramites;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching tramites: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showTramiteDetails(BuildContext context, dynamic tramite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
      String formatDate(String? date) {
        if (date == null) return 'N/A';
        final parsedDate = DateTime.parse(date);
        return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute}:${parsedDate.second}';
      }

      String formatEstado(String estado) {
        switch (estado) {
        case 'pending':
          return 'Pendiente';
        case 'approved':
          return 'Aprobado';
        default:
          return estado;
        }
      }

      return AlertDialog(
        title: Text('Detalles del Trámite'),
        content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ID: ${tramite['id']}'),
          Text('Tipo de Trámite: ${tramite['tipo_tramite']}'),
          Text('Carga ID: ${tramite['carga_id']}'),
          Text('Fecha de Creación: ${formatDate(tramite['fecha_creacion'])}'),
          Text('Estado: ${formatEstado(tramite['estado'])}'),
          Text('Fecha de Término: ${formatDate(tramite['fecha_termino'])}'),
        ],
        ),
        actions: [
        TextButton(
          child: Text('Cerrar'),
          onPressed: () {
          Navigator.of(context).pop();
          },
        ),
        ],
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tramites.length,
              itemBuilder: (context, index) {
                final tramite = _tramites[index];
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
                        "Tipo de Trámite: ${tramite['tipo_tramite']}",
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
                              text: 'Carga ID: ${tramite['carga_id']}\n',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Estado: ${tramite['estado']}\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 100, 209, 203),
                          ),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Ver más',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _showTramiteDetails(context, tramite);
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