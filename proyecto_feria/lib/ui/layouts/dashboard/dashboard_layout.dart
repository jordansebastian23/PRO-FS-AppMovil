import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/tramitador/card_archives.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/widgets/custom_drawer.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/tramitador/card_payments.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/tramitador/card_procedures.dart';
import 'package:proyecto_feria/services/google_auth.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/conductor/card_assigned_load.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/conductor/card_remove_load.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/conductor/card_status_procedure.dart';

class DashboardLayout extends StatefulWidget {
  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  final AutenticacionGoogle _authService = AutenticacionGoogle();
  String? _userName;

  final String rol = 'Tramitador';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = _authService.getCurrentUser();
    setState(() {
      _userName = user?.displayName ?? 'Usuario';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(118),
      child: AppBar(
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        toolbarHeight: 120.0,
        title: Text(
          'Bienvenido ${_userName ?? 'Cargando...'}!',
          style: GoogleFonts.libreFranklin(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 39, 46, 75),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: rol == 'Tramitador' ? _buildTramitadorWidgets() : 
      Column(
        children: [
          //Si rol es != se muestra esto
          CardRemoveLoad(),
          SizedBox(height: 15),
          Divider(
          color: Color.fromARGB(255, 105, 148, 216),
          endIndent: 125,
          indent: 125,
          thickness: 3,
          ),
          SizedBox(height: 15),
          CardStatudProcedure(),
          SizedBox(height: 15),
          CardAssignedLoad(),
          
        ],
      ),
      
    );
  }

  Widget _buildTramitadorWidgets() {
    return Column(
      //Si rol es tramitador se muestra esto
      children: [
        CardPayment(),
        SizedBox(height: 15),
        Divider(
          color: Color.fromARGB(255, 105, 148, 216),
          endIndent: 125,
          indent: 125,
          thickness: 3,
        ),
        SizedBox(height: 15),
        CardProcedures(),
        SizedBox(height: 15),
        CardArchives(),
      ],
    );
  }
}
