import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/exception/auth_exception.dart';
import 'package:todo_list/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth}) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      var userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredencial.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException('E-mail já utilizado, por favor escolha outro e-mail');
        } else {
          throw AuthException('Você já se cadastrou pelo Google');
        }
      } else {
        throw AuthException(e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on PlatformException catch (e) {
      throw AuthException(e.message ?? 'Erro ao realizar login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw AuthException('Login ou senha inválidos');
      }
      throw AuthException(e.message ?? 'Erro ao realizar login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException('Cadastro realizado com o google, não pode ser resetado a senha');
      } else {
        throw AuthException('E-mail não cadastrado');
      }
    } on PlatformException catch (_) {
      throw AuthException('Erro ao resetar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;

    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

        if (loginMethods.contains("password")) {
          throw AuthException(
              'Você utilizou o e-mail para cadastro no TodoList, caso tenha esquecido sua senha clique no link esqueci minha senha');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final userCredential = await _firebaseAuth.signInWithCredential(firebaseCredential);
          return userCredential.user;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException('''
          Login inválido, você se registrou no TodoList com os seguintes meios:
          ${loginMethods?.join('.')}
        ''');
      } else {
        throw AuthException('Erro ao realizar login');
      }
    } catch (e) {
      throw AuthException('Erro ao realizar login');
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
