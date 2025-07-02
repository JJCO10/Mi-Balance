import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      print("Error al registrar: $e");
      return null;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
