import 'package:flutter/material.dart';
import 'package:proyecto_feria/screen/login.dart';
import 'package:proyecto_feria/utils/custom_textformfield.dart';
import 'package:proyecto_feria/services/create_account.dart';

class CrearCuenta extends StatefulWidget {
  @override
  _CrearCuentaState createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _createAccount() async {
    if (passwordController.text != confirmPasswordController.text) {
      // Show error if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    try {
      final response = await CreateAccountService.createUser(
        email: emailController.text,
        displayName: nameController.text,
        phoneNumber: phoneController.text,
        password: passwordController.text,
      );

      if (response['message'] != null) {
        Navigator.push(
          context,
          // Revisar despues el ruteo
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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
            // Other UI components like TextFormField
            TextFormField(
              controller: nameController,
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
                hint: 'Nombre',
                label: 'Nombre',
                icon: Icons.person_outline,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
                hint: 'Email',
                label: 'Email',
                icon: Icons.email_outlined,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: phoneController,
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
                hint: 'Numero de telefono',
                label: 'Numero de telefono',
                icon: Icons.phone_outlined,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: CustomImputs.loginInputStyle(
                hint: 'Contraseña',
                label: 'Contraseña',
                icon: Icons.lock_outline_rounded,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
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
                child: CustomOutlinedButton(
                  onPressed: _createAccount,
                  text: 'Crear Cuenta',
                  textColor: Colors.black,
                  isFilled: true,
                  color: Color(0xFF64D1CB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}