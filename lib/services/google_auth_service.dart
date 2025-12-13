import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Get user data
      final String? email = googleUser.email;
      final String? name = googleUser.displayName;
      final String? photoUrl = googleUser.photoUrl;
      final String? idToken = googleAuth.idToken;

      return {
        'email': email,
        'name': name,
        'photoUrl': photoUrl,
        'idToken': idToken,
      };
    } catch (error) {
      print('Google Sign-In error: $error');
      return null;
    }
  }

  Future<bool> authenticateWithBackend(String idToken, bool isLogin) async {
    try {
      final url = isLogin
          ? 'http://192.168.18.8:5000/google-login'
          : 'http://192.168.18.8:5000/google-register';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          // Save token to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setBool('isGoogleLogin', true);
          await prefs.setString('userEmail', result['data']['email']);
          await prefs.setString('userName', result['data']['username']);
          await prefs.setString('token', result['token']); // Assuming backend returns a token

          return true;
        }
      }
      return false;
    } catch (error) {
      print('Backend authentication error: $error');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
  }
}
