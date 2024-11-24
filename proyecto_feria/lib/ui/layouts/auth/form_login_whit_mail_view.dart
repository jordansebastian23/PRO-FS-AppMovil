import 'package:flutter/material.dart';
import 'package:proyecto_feria/ui/shared/buttons/custom_outlined_button.dart';
import 'package:proyecto_feria/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:proyecto_feria/ui/layouts/auth/form_create_account_view.dart';
import 'package:proyecto_feria/ui/layouts/auth/form_forget_password_view.dart';
import 'package:proyecto_feria/ui/shared/inputs/custom_inputs.dart';
import 'package:proyecto_feria/ui/shared/link_text.dart';

class EmailLoginView extends StatelessWidget {
  const EmailLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 46, 75),
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 39, 46, 75),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, ingresa al',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sistema',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              //validar campos
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInput(
                hint: 'Email',
                label: 'Email',
                icon: Icons.email_outlined,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              //validar campos
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInput(
                hint: 'Contraseña',
                label: 'Contraseña',
                icon: Icons.lock_outline_rounded,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 150),
              child: LinkText(text: 'Olvidaste tu contraseña?',
                onPressed: (){
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>   ResetPasswordView(),
                              ),
                            );
                },
              ),
            ),
            SizedBox(height: 20),
            
            Center(
              child: SizedBox(
                width: 250,
                height: 60,
                child: CustomOutlinedButton(onPressed: (){
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>   DashboardLayout(),
                              ),
                            );
                },
                  text: 'Ingresar',
                  textColor: Colors.black,
                  isFilled: true,
                  color: Color(0xFF64D1CB),
                ),
              ),
            ),
            SizedBox(height: 20),
            //No tienes cuenta
            Row(
              children: [
                Text('¿No tienes cuenta?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                LinkText(
                  text: 'Create una',
                  onPressed: (){
                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>   CreateAccountView(),
                              ),
                            );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
