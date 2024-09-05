import 'package:flutter/material.dart';

class ArchivesPage extends StatelessWidget {
  const ArchivesPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(25)
          ),
          child: ListTile(
            title: Text('Archivo Pendiente',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600
            )
            ),
            subtitle: Text.rich(TextSpan(children: [
              TextSpan(
                text: 'Carga número: 1337\n',
                style: TextStyle(
              color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                )
              ),
              TextSpan(
                text: 'Motivo: Documentos de identidad',
                style: TextStyle(
              color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                )
              )
            ])
            ),
            trailing: Container(
              width: 100,
              height: 100,
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 255, 94, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                onPressed: () {
                },
                child: Text('Ver \n Detalles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),),
              ),
            )
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.add,
        size: 30,
        color: Colors.white,
        ),
        backgroundColor: Color.fromARGB(255, 255, 94, 0),
      ),
    );
  }
}