import 'package:flutter/material.dart';
import 'package:proyecto_feria/screen/Crear_cuenta.dart';
import 'package:proyecto_feria/screen/olvidar_pass.dart';
import 'package:proyecto_feria/utils/custom_textformfield.dart';
import 'package:proyecto_feria/utils/link_text.dart';

class LoginCorreo extends StatelessWidget {
  const LoginCorreo({super.key});

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
              decoration: CustomImputs.loginInputStyle(
                hint: 'Email',
                label: 'Email',
                icon: Icons.email_outlined,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              //validar campos
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
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
                                builder: (context) =>   OlvidarPass(),
                              ),
                            );
                  print('Olvidaste tu contraseña');
                },
              ),
            ),
            SizedBox(height: 20),
            
            Center(
              child: SizedBox(
                width: 250,
                height: 60,
                child: CustomOutlinedButton(onPressed: (){},
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
                                builder: (context) =>   CrearCuenta(),
                              ),
                            );
                    print('Crear cuenta');
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
