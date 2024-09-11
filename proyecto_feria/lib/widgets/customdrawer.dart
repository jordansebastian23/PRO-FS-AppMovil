import 'package:flutter/material.dart';
import 'package:proyecto_feria/screen/login.dart';
import 'package:proyecto_feria/services/google_auth.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
    final AutenticacionGoogle _authService = AutenticacionGoogle();
    String? _userName;
    String? _userPhotoUrl;


  @override

    void initState() {
    super.initState();
    _loadUserInfo();
  }
  Future<void> _loadUserInfo() async {
    final user = _authService.getCurrentUser();
    setState(() {
      _userName = user?.displayName ?? 'Cargando...';
      _userPhotoUrl = user?.photoURL;
    });
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
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        
            ListTile(
            title: Text('Cerrar sesión'),
            onTap: () async {
                        await _authService.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
            ),
        ],
      ),
    );
  }
}