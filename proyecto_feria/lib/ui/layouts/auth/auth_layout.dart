import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/shared/buttons/custom_outlined_button.dart';
import 'package:proyecto_feria/ui/layouts/auth/widgets/custom_divider.dart';
import 'package:proyecto_feria/ui/layouts/auth/widgets/custom_title.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:proyecto_feria/ui/layouts/auth/form_create_account_view.dart';
import 'package:proyecto_feria/ui/layouts/auth/form_login_whit_mail_view.dart';
import 'package:proyecto_feria/ui/shared/colors.dart';
import 'package:proyecto_feria/services/google_auth.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final AutenticacionGoogle _googleSignIn = AutenticacionGoogle();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 46, 75),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //title and image icon
                CustomTitle(),

                SizedBox(height: 20),

                CustomOutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailLoginView(),
                      ),
                    );
                  },
                  text: 'Ingresar con correo',
                  textColor: Colors.black,
                  isFilled: true,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                SizedBox(height: 10),
                CustomOutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAccountView(),
                        ),
                      );
                    },
                    text: 'Crear Cuenta',
                    isFilled: true,
                    color: Color.fromARGB(255, 255, 255, 255),
                    textColor: Colors.black),

                CustomDivider(),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    User? user = await _googleSignIn.autentificaciongoogle();
                    if (user != null) {
                      //Navegar hacia HomePage()
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardLayout(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Inicio de sesión con Google fallido',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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

                Text(
                  'Hacer trámites jamás fue más fácil.',
                  style: TextStyle(
                    color: CustomColor.buttons,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
