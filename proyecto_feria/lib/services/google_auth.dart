import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutenticacionGoogle {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> autentificaciongoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Automatically store user in Django on first login
        final token = await _checkOrCreateUserInDjango(user);
        // Store token and login type locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('loginType', 'google');
      }

      return user;
    } catch (e) {
      print('Error en autentificación con Google: $e');
      return null;
    }
  }

  Future<void> logoutGoogleUser() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Método para obtener el usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String> _checkOrCreateUserInDjango(User user) async {
    // Asignar ip del servidor
    final url = Uri.parse('http://10.32.104.37:8000/check_or_create_user/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': user.uid,
        'email': user.email,
        'display_name': user.displayName,
        'photo_url': user.photoURL,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to check or create user in Django');
    }
  }
}

