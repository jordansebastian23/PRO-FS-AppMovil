import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/tabs/archives.dart';
import 'package:proyecto_feria/tabs/payments.dart';
import 'package:proyecto_feria/tabs/procedures.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _appBarTitle = 'Pagos';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _appBarTitle = 'Portal de pagos';
            break;
          case 1:
            _appBarTitle = 'Portal de archivos';
            break;
          case 2:
            _appBarTitle = 'Historial de tramites';
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: Stack(
                children: [
                  AppBar(
                    //centerTitle: true,
          toolbarHeight: 93,
          backgroundColor: Color.fromARGB(255, 39, 46, 75),
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(_appBarTitle,
            
            textAlign: TextAlign.right,
              style: GoogleFonts.libreFranklin(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/Avatar.png'),
                radius: 36,
              ),
            ),
          ],
        bottom: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),

          child: Container(
            color: Colors.white,
            child: TabBar(
                controller: _tabController,
                indicatorColor: Color.fromARGB(255, 100, 209, 203),
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Color.fromARGB(255, 100, 209, 203),
                unselectedLabelColor: Color.fromARGB(255, 39, 46, 75),

                indicatorWeight: 5,
                tabs: [
                  Tab(text: 'Pagos'),
                  Tab(text: 'Archivos'),
                  Tab(text: 'Tramites'),
                ],
              ),
          ),
        ),
        ),
                ],
              ),
            ),
      body: TabBarView(

        controller: _tabController,
        children: [
          PaymentsPage(),
          ArchivesPage(),
          ProceduresPage(),
        ],
      ),
    );
  }
}
