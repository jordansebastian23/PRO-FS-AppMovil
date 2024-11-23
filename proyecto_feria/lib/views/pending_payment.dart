import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PendingPaymentPage extends StatelessWidget {
  final Map<String, dynamic> pago;
  const PendingPaymentPage({super.key, required this.pago});

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
          title: Text('Pago pendiente',
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
            shape: CircleBorder(),
            margin: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 5),
            elevation: 10,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 0, 0, 0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  image: AssetImage('assets/images/contenedordark.jpg'),
                  fit: BoxFit.cover,)
              ),
              child: ListTile(
                title: Text("Pago #${pago['id']}\n",
                style: TextStyle(color:Color.fromARGB(255, 142, 178, 235),
                fontSize: 22,
                fontWeight: FontWeight.bold),
                ),
                subtitle: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Carga número: ${pago['carga_id']}\n',
                    style: TextStyle(
                      color: Color.fromARGB(255, 247, 247, 247),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    TextSpan(
                    text: "Fecha de creación: ${DateFormat('dd/MM/yy HH:mm:ss').format(DateTime.parse(pago['fecha_creacion']))}\n",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: "Estado: ${pago['estado']}\n",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),
                    TextSpan(
                    text: "Monto: \$${pago['monto'].toStringAsFixed(0)}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                    ),
                    )
              
                ]
                )
                ),
                )
              ),
            ),
            SizedBox(
              height: 60,
            ),
            if (pago['estado'] == 'pendiente') ...[
              Text(
              'Selecciona tu metodo de pago',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              ),
              Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 237, 240),
                borderRadius: BorderRadius.circular(25),
              ),
              margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Column(
                  children: [
                  Text(
                    'Crédito',
                    style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                    width: 80,
                    height: 58,
                    child: Image.asset('assets/images/visa.png'),
                    ),
                    iconSize: 25,
                    onPressed: () {},
                  ),
                  ],
                ),
                Column(
                  children: [
                  Text(
                    'Débito',
                    style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                    width: 80,
                    height: 58,
                    child: Image.asset('assets/images/mastercard.png'),
                    ),
                    iconSize: 25,
                    onPressed: () {},
                  ),
                  ],
                ),
                Column(
                  children: [
                  Text(
                    'Transferencia',
                    style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                    width: 80,
                    height: 58,
                    child: Image.asset('assets/images/visa.png'),
                    ),
                    iconSize: 25,
                    onPressed: () {},
                  ),
                  ],
                ),
                ],
              ),
              ),
            ] else if (pago['estado'] == 'approved') ...[
              Text(
              'Payment approved already',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              ),
            ]
            
        ],
      ),
    );
  }
}