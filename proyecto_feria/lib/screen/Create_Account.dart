import 'package:flutter/material.dart';
import 'package:proyecto_feria/screen/Login_whit_mail.dart';
import 'package:proyecto_feria/utils/custom_textformfield.dart';
import 'package:proyecto_feria/utils/link_text.dart';

class CrearCuenta extends StatelessWidget {
  const CrearCuenta({super.key});

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
              'Para empezar, crea tu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'cuenta',
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
                hint: 'Nombre',
                label: 'Nombre',
                icon: Icons.person_outline,
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
                hint: 'Numero de telefono',
                label: 'Numero de telefono',
                icon: Icons.phone_outlined,
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
            TextFormField(
              //validar campos
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
                hint: 'Confirmar contraseña',
                label: 'Confirmar contraseña',
                icon: Icons.lock_outline_rounded,
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
                                builder: (context) =>   CuentaCreada(),
                              ),
                            );
                },
                  text: 'Crear Cuenta',
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
                Text('¿Ya tenias cuenta?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                LinkText(
                  text: 'Inicia sesion',
                  onPressed: (){
                    Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>   LoginCorreo(),
                              ),
                            );
                    print('Iniciar sesion');
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

class CuentaCreada extends StatelessWidget {
  const CuentaCreada({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 39, 46, 75),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/Sticker.png', width: 150, height: 150),
          SizedBox(height: 10),
          Text(
            'Tu cuenta ha sido creada exitosamente',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 300,
            height: 60,
            child: CustomOutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginCorreo(),
                  ),
                );
              },
              text: 'Volver a iniciar sesion',
              textColor: Colors.black,
              isFilled: true,
              color: Color(0xFF64D1CB),
            ),
          ),
        ],
      ),
    );
  }
}
