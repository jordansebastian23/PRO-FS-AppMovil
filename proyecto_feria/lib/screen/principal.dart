import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_feria/widgets/customarchives.dart';
import 'package:proyecto_feria/widgets/customdrawer.dart';
import 'package:proyecto_feria/widgets/custompayment.dart';
import 'package:proyecto_feria/widgets/customprocedures.dart';
import 'package:proyecto_feria/services/google_auth.dart';


class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final AutenticacionGoogle _authService = AutenticacionGoogle();
  String? _userName;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(118),
        child: AppBar(
          iconTheme: IconThemeData(
            size: 30,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          toolbarHeight: 120.0,
          //centerTitle: true,
          title: 
          Text(
            'Bienvenido ' + (_userName ?? 'Cargando...') + '!',
            textAlign: TextAlign.start,
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
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomWidgetPayment(),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Color.fromARGB(255, 105,148,216),
              endIndent: 125,
              indent: 125,
              thickness: 3,
            ),
            SizedBox(
              height: 15,
            ),
            CustomWidgetProcedures(),
            SizedBox(
              height: 15,
            ),
            CustomWidgetArchives(),
          ],
        )
      ),
    );
  }
}