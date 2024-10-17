import 'package:flutter/material.dart';
import 'package:proyecto_feria/views/pending_payment.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                title: Text("Pago #115",
                style: TextStyle(color:Color.fromARGB(255, 105, 148, 216),
                fontSize: 20,
                fontWeight: FontWeight.bold),
                ),
                subtitle: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Carga número: 1337\n',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "A pagar: \$120.000",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                    ),
                  ),
                ])),
              trailing: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 100, 209, 203)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                icon: Text('Ir a pagar',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                ),            
                onPressed: () { 
                  // navigate to pending payments and revert back to payments
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PendingPaymentPage()),
                  );
                },
                ),
                )
              ),
            ),
        ],
      ),
      
    );
  }
}
