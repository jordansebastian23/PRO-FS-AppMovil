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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text('Historial tramites',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),),
      ),
      body: Container(
        width: double.maxFinite,
        height: 40,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 19,
              child: SizedBox(
                width: double.maxFinite,
                height: 40,
                
                child: Text(
                  'Filtros disponibles',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 270,
              top: 5,
              child: SizedBox(
              width: double.maxFinite,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
                child: DropdownButton<String>(
                  hint: Text('Seleccionar'),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
                  items: <String>['Filter 1', 'Filter 2', 'Filter 3']
                    .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                    }).toList(),
                  onChanged: (_) {
                    setState(() {
                      // valor de la variable que se usa para filtrar
                    });
                  },
                  ),
              ),
              ),
              ),
            
          ],

        ),

      ),
      floatingActionButton: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      FloatingActionButton(
        child: Icon(
          Icons.delete
        ),
        onPressed: () {
          //...
        },
        heroTag: null,
      ),
      SizedBox(
        height: 10,
      ),
      FloatingActionButton(           
        child: Icon(
          Icons.star
        ),
        onPressed: () {
          //...
        },
      )
    ]
  )
    );
  }
}