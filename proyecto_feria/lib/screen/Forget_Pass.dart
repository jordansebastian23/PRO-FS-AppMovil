import 'package:flutter/material.dart';
import 'package:proyecto_feria/screen/Login_whit_mail.dart';
import 'package:proyecto_feria/utils/custom_textformfield.dart';
import 'package:proyecto_feria/utils/form_code_otp.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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
              '¿Olvidaste tu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'contraseña?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('No te preocupes, te ayudaremos a recuperarla\n'
                'Por favor, ingresa la dirección de correo\nelectrónico vinculada a tu cuenta.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
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
            
            Center(
              child: SizedBox(
                width: 250,
                height: 60,
                child: CustomOutlinedButton(onPressed: (){
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>   VerifyOTP(),
                              ),
                            );
                },
                  text: 'Enviar codigo',
                  textColor: Colors.black,
                  isFilled: true,
                  color: Color(0xFF64D1CB),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


class VerifyOTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 46, 75),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 46, 75),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recuperar Contraseña',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Ingresa el código de verificación que acabamos de enviar a tu dirección electrónica',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FormCodeOtp(),
                FormCodeOtp(),
                FormCodeOtp(),
                FormCodeOtp(),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 250,
                height: 60,
                child: CustomOutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(), 
                      ),
                    );
                  },
                  text: 'Verificar Codigo',
                  isFilled: true,
                  color: Color(0xFF64D1CB),
                  textColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 46, 75),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 46, 75),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crea una nueva',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Contraseña',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tu nueva contraseña debe tener al menos 8 caracteres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              //validar campos
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
                hint: 'Nueva Contraseña',
                label: 'Nueva Contraseña',
                icon: Icons.lock_outline,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              //validar campos
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
                hint: 'Confirma Contraseña',
                label: 'Confirma Contraseña',
                icon: Icons.lock_outline,
              ),
            ),

            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 350,
                height: 60,
                child: CustomOutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyPass(), // Reemplaza con tu página de destino
                      ),
                    );
                  },
                  text: 'Restablecer Contraseña',
                  isFilled: true,
                  color: Color(0xFF64D1CB),
                  textColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyPass extends StatelessWidget {
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
            'Tu contraseña ha sido cambiada exitosamente',
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



