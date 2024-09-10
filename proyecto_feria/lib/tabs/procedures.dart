import 'package:flutter/material.dart';

class ProceduresPage extends StatefulWidget {
  const ProceduresPage({super.key});

  @override
  State<ProceduresPage> createState() => _ProceduresPageState();
}

class _ProceduresPageState extends State<ProceduresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 200, top: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 1),
                      decoration: BoxDecoration(
                        
                        border: Border.all(
                          color: Color.fromARGB(255,151, 151, 151),
                          width: 1,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      
                      child: DropdownButton(
                        //borderRadius: BorderRadius.circular(25),
                        hint: Text('Filtrar por:'),
                        value: null,

                        items: ['Tramites', 'Tramites pendientes', 'Tramites completados']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          // Add your logic here
                        },
                      ),
                    ),
                  ),
                  
                ],
              ),
              ),
          ),


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
                title: Text("Tramite N° 1337",
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
                    text: "Tipo de carga: \$Full\n",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: "Destinatario: \$Dest\n",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: "Fecha de tramitacion: 12/12/2021",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                    ),
                  )
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
                icon: Text('Ver más',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                ),            
                onPressed: () { 
          
                },
                ),
                )
              ),
            ),
        ],
      ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(19.0),
        child: FloatingActionButton.extended(onPressed: () {
          //poner redondo el boton
        
        }, label: Text('Iniciar nuevo tramite',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        ),
        backgroundColor: const Color.fromARGB(255, 100, 209, 203),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),

        ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}