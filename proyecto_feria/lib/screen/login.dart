import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_feria/pages/home_page.dart';
import 'package:proyecto_feria/screen/Create_Account.dart';
import 'package:proyecto_feria/screen/Login_whit_mail.dart';
import 'package:proyecto_feria/services/google_auth.dart';
import 'package:proyecto_feria/utils/custom_textformfield.dart';

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
                children: [
                  Text('LogiQuick',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Image.asset('assets/images/logiquick.png', width: 450 ),
                  SizedBox(height: 10),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                  
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: CustomOutlinedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginCorreo(),
                              ),
                            );
                          },
                          text: 'Ingresar con correo',
                          textColor: Colors.black,
                          isFilled: true,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: CustomOutlinedButton(onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>   CrearCuenta(),
                              ),
                            );
                        },
                          text: 'Crear Cuenta',
                          isFilled: true,
                          color: Color.fromARGB(255, 255, 255, 255),
                          textColor: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1.0,
                        width: 100.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text('O',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 1.0,
                        width: 100.0,
                        color: Colors.white,
                      ),
                    ],

                  )),


                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                  SizedBox(height: 20),

                  Text('Hacer trámites jamás fue más fácil.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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