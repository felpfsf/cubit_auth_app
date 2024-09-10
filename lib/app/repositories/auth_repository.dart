import 'dart:developer';

import 'package:cubit_auth_app/app/core/exceptions/auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository({required FirebaseAuth auth}) : _auth = auth;

  User? getCurrentUser() => _auth.currentUser;

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log('Erro Login: $e');
      switch (e.code) {
        case 'invalid-credential':
          throw LoginException(message: 'Usuário / senha incorretos');
        default:
          throw LoginException(message: 'Erro ao realizar login');
      }
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw RegisterException(message: 'Email já cadastrado');
        default:
          throw RegisterException(message: 'Erro ao realizar login');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw LogoutException(message: 'Erro ao realizar logout ${e.toString()}');
    }
  }
}
