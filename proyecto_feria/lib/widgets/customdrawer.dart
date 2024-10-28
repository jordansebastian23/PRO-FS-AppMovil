import 'package:flutter/material.dart';
import 'package:proyecto_feria/screen/login.dart';
import 'package:proyecto_feria/pages/home_page.dart';
import 'package:proyecto_feria/services/google_auth.dart';
import 'package:proyecto_feria/services/session_manager.dart';
import 'package:proyecto_feria/services/session_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AutenticacionGoogle _authService = AutenticacionGoogle();
  String? _userName;
  String? _userPhotoUrl;
  String? _loginType;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
  // Get the login type from SessionManager
  _loginType = await SessionManager.getLoginType();

  if (_loginType == "google") {
    final user = _authService.getCurrentUser();
    setState(() {
      _userName = user?.displayName ?? 'Google Usuario';
      _userPhotoUrl = user?.photoURL;
    });
  } else if (_loginType == "credentials") {
    try {
      final userData = await SessionService.getUserData();
      setState(() {
        _userName = userData['display_name'] ?? 'Usuario';
        _userPhotoUrl = null; // Placeholder for credential users
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _userName = 'Usuario desconocido';
        _userPhotoUrl = null;
      });
    }
  } else {
    setState(() {
      _userName = 'Usuario desconocido';
      _userPhotoUrl = null;
    });
  }
}


  Future<void> _logout() async {
    if (_loginType == "google") {
      await _authService.logoutGoogleUser();
    } else if (_loginType == "credentials") {
      await SessionService.logoutCredentialsUser();
    }

    // Clear the login type
    await SessionManager.logout();

    // Navigate to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 39, 46, 75),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _userPhotoUrl != null
                      ? NetworkImage(_userPhotoUrl!)
                      : AssetImage('assets/images/Avatar.jpg') as ImageProvider,
                ),
                Text(
                  _userName ?? 'Cargando...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Inicio'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PrincipalPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: Text('Cerrar sesión'),
            onTap: _logout, // Use the logout function here
          ),
        ],
      ),
    );
  }
}
