import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/tabs/archives.dart';
import 'package:proyecto_feria/tabs/payments.dart';
import 'package:proyecto_feria/tabs/procedures.dart';
import 'package:proyecto_feria/widgets/customdrawer.dart';

class TabbedHomePage extends StatefulWidget {
  final int initialIndex;
  const TabbedHomePage({super.key, this.initialIndex = 0});

  @override
  _TabbedHomePageState createState() => _TabbedHomePageState();
}

class _TabbedHomePageState extends State<TabbedHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _appBarTitle = 'Pagos';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialIndex);
    _setAppBarTitle(widget.initialIndex);
    _tabController.addListener(() {
      setState(() {
        _setAppBarTitle(_tabController.index);
      });
    });
  }

  void _setAppBarTitle(int index) {
    switch (index) {
      case 0:
        _appBarTitle = 'Portal de pagos';
        break;
      case 1:
        _appBarTitle = 'Portal de archivos';
        break;
      case 2:
        _appBarTitle = 'Historial de trámites';
        break;
      default:
        _appBarTitle = 'Portal de pagos';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Stack(
          children: [
            AppBar(
              iconTheme: IconThemeData(
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              centerTitle: true,
              toolbarHeight: 93,
              backgroundColor: Color.fromARGB(255, 39, 46, 75),
              title: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  _appBarTitle,
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
                      Tab(text: 'Trámites'),
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
