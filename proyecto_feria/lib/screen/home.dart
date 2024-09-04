import 'package:flutter/material.dart';
import 'package:proyecto_feria/tabs/Archives.dart';
import 'package:proyecto_feria/tabs/Payments.dart';
import 'package:proyecto_feria/tabs/Procedures.dart';
import 'package:proyecto_feria/widgets/customdrawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
              },
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 0, 10, 156),
          title: Text('LogiQuick'),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.white,
              child: TabBar(
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                indicatorWeight: 5,
                indicatorColor: Color.fromARGB(255, 253, 173, 0),
                labelColor: const Color.fromARGB(255, 0, 3, 7),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Pagos'),
                  Tab(text: 'Archivos'),
                  Tab(text: 'Tramites'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            PaymentsPage(),
            ArchivesPage(),
            ProceduresPage(),
          ],
        ),
      )
    );
  }
}