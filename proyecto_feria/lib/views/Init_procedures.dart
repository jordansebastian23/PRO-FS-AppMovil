import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InitProceduresPage extends StatefulWidget {
  const InitProceduresPage({super.key});

  @override
  State<InitProceduresPage> createState() => _InitProceduresPageState();
}

class _InitProceduresPageState extends State<InitProceduresPage> {
  bool switch1 = false;
  bool switch2 = false;
  TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

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
          title: Text(
            'Nuevo trámite',
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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Seleccione el tipo de carga',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Switch.adaptive(
                      value: switch1,
                      onChanged: (bool value) {
                        setState(() {
                          switch1 = value;
                          if (value) {
                            switch2 = false;
                          }
                        });
                      },
                      activeColor: Color.fromARGB(255, 100, 209, 203), // Color del switch
                      inactiveThumbColor: Colors.grey,
                    ),
                    Text(
                      'Carga Completa',
                      style: TextStyle(
                        color: switch1 ? Color.fromARGB(255, 100, 209, 203) : Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Switch.adaptive(
                      value: switch2,
                      onChanged: (bool value) {
                        setState(() {
                          switch2 = value;
                          if (value) {
                            switch1 = false;
                          }
                        });
                      },
                      activeColor: Color.fromARGB(255, 100, 209, 203), // Color del switch
                      inactiveThumbColor: Colors.grey,
                    ),
                    Text(
                      'Carga Parcial',
                      style: TextStyle(
                        color: switch2 ? Color.fromARGB(255, 100, 209, 203) : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Destinatario',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
          
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Numero de carga',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon:
                              Icon(Icons.calendar_today), // Icono de calendario
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre Tramitador',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Rut Tramitador',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
              Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Rut Tramitador',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Peso de carga',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),             
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                    children: [
                      //Floatingbutton "Ir a pagar" y "Subir archivos"
                      Expanded(
                        child: FloatingActionButton.extended(
                          onPressed: () {
                          
                          },
                          label: Text('Ir a pagar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                          backgroundColor: Color.fromARGB(255,100, 209, 203),
                          heroTag: 'btn1',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: FloatingActionButton.extended(
                          onPressed: () {
                          
                          },
                          label: Text('Subir archivos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),  
                          backgroundColor: Color.fromARGB(255,	100, 209, 203),
                          heroTag: 'btn2',
                        ),
                      ),
                    ],
                  )
          
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
