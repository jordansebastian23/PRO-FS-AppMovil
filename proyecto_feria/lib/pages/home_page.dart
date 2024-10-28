import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/widgets/mobile_tramitador/customarchives.dart';
import 'package:proyecto_feria/widgets/customdrawer.dart';
import 'package:proyecto_feria/widgets/mobile_tramitador/custompayment.dart';
import 'package:proyecto_feria/widgets/mobile_tramitador/customprocedures.dart';
import 'package:proyecto_feria/services/google_auth.dart';
import 'package:proyecto_feria/widgets/mobile_conductor/customcargaasignada.dart';
import 'package:proyecto_feria/widgets/mobile_conductor/customretirar.dart';
import 'package:proyecto_feria/widgets/mobile_conductor/customstatusprocedures.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
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
          CustomRetiroStatus(),
          SizedBox(height: 15),
          Divider(
          color: Color.fromARGB(255, 105, 148, 216),
          endIndent: 125,
          indent: 125,
          thickness: 3,
          ),
          SizedBox(height: 15),
          CustomStatusProcedures(),
          SizedBox(height: 15),
          CustomCargaAsignada(),
          
        ],
      ),
      
    );
  }

  Widget _buildTramitadorWidgets() {
    return Column(
      //Si rol es tramitador se muestra esto
      children: [
        CustomWidgetPayment(),
        SizedBox(height: 15),
        Divider(
          color: Color.fromARGB(255, 105, 148, 216),
          endIndent: 125,
          indent: 125,
          thickness: 3,
        ),
        SizedBox(height: 15),
        CustomWidgetProcedures(),
        SizedBox(height: 15),
        CustomWidgetArchives(),
      ],
    );
  }
}
