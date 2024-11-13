import 'package:flutter/material.dart';
import 'package:proyecto_feria/services/pagos_view.dart';
import 'package:proyecto_feria/views/pending_payment.dart';


class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pagos.length,
              itemBuilder: (context, index) {
                final pago = _pagos[index];
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
                        "Pago #${pago['id']}",
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
                              text: 'Carga número: ${pago['carga_id']}\n',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "A pagar: \$${pago['monto']}",
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
                          'Ir a pagar',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PendingPaymentPage(pago: pago),
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
