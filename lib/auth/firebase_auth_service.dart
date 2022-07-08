import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

  static Future<User?> loginAdmin(String email, String pass) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return credential.user;
  }

  static Future<void> logoutAdmin() {
    return _auth.signOut();
  }
}