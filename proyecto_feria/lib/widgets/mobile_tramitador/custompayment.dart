import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/pages/tab_control.dart';
import 'package:proyecto_feria/services/pagos_view.dart';
import 'package:proyecto_feria/utils/Card_principal_utils.dart';
import 'package:proyecto_feria/views/pending_payment.dart';

class CustomWidgetPayment extends StatefulWidget {
  const CustomWidgetPayment({super.key});

  @override
  _CustomWidgetPaymentState createState() => _CustomWidgetPaymentState();
}
  //Colores
  //Color container: Color.fromARGB(255,235,237,240),
  //Color Divider: 6994D8
  //Color Texto: black

  class _CustomWidgetPaymentState extends State<CustomWidgetPayment> {
  List<dynamic> _pagos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPagos();
  }

  Future<void> _fetchPagos() async {
    try {
      final pagos = await PagosView.getUserPagos();
      setState(() {
        _pagos = pagos;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching pagos: $e");
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
                    'Pagos pendientes',
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
                          builder: (context) => TabbedHomePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              subtitle: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                      children: _pagos.take(2).map((pago) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CardMenuPrincipal(
                        title: 'Pago #${pago['id']}',
                        subtitle: 'Carga número: ${pago['carga_id']}\nA pagar: \$${pago['monto']}',
                        image: 'assets/images/icono-pagos.png',
                        onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TabbedHomePage(initialIndex: 0),
                              ),
                            );
                          },
                        ),
                      );
                      }).toList(),
                    ),
            ),
          ),
          if (_pagos.length > 2)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabbedHomePage(),
                  ),
                );
              },
              child: Text('Leer más'),
            ),
        ],
      ),
    );
  }
}