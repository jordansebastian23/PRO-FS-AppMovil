import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 10, 156),
            borderRadius: BorderRadius.circular(25)
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset('assets/images/Avatar.png',
              height: 150,
              width: 100,
                fit: BoxFit.cover,              
              ),
            ),
            title: Text("Pago #115",
            style: TextStyle(color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(TextSpan(children: [
              TextSpan(
                text: 'Carga número: 1337\n',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "A pagar: \$120.000",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                ),
              ),
            ])),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios,
            color: Colors.white,
            size: 30,
            ),
            onPressed: () {
              
            },)
          ),
        ),
      ),
      
    );
  }
}
