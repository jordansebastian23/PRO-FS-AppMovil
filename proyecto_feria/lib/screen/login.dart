import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_feria/screen/principal.dart';
import 'package:proyecto_feria/services/google_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AutenticacionGoogle _googleSignIn = AutenticacionGoogle();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 46, 75),
      body: Stack(
        children: [
            Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('LogiQuick',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logiquick.png',
                        fit: BoxFit.contain,
                        height: 272,
                        width: 307,
                      ),
                      Positioned(
                        //top: 50, // Ajusta esta posición según sea necesario
                        child: Image.asset(
                          'assets/images/logo-blanco.png', // Cambia a la ruta de tu imagen superpuesta
                          fit: BoxFit.contain,
                          height: 268,
                          width: 300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(children: [
                      TextSpan(
                        text: 'SITRANS\n',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Depósito & Logística',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 24,
                          
                        ),
                      ),
                    ])
                  ),
                  
                  SizedBox(height: 15),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Color(0xFF1b141a),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                        
                      ),
                    ),
                    onPressed: ()  async {
                      User? user = await _googleSignIn.autentificaciongoogle();
                      if (user != null) {
                        //Navegar hacia HomePage()
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrincipalPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Inicio de sesión con Google fallido', style: TextStyle( fontWeight: FontWeight.bold),),
                          ),
                        );
                      }
                    
                    },
                    icon: Image.asset(
                      'assets/images/google_icon1.png',
                      height: 32.0,
                      width: 32.0,
                    ),
                    label: Text(
                      'Ingresar con Google',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
        ),
    );
  }
}