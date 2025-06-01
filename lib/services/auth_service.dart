import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Регистрация пользователя
  Future<String?> registerUser({
    required String email,
    required String password,
    required String phone,
    required String birthDate,
    String? firstName,
    String? middleName,
    String? bmwModel,
  }) async {
    try {
      // Создание пользователя
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Отправка письма с подтверждением
      await userCredential.user!.sendEmailVerification();

      // Сохранение дополнительных данных в Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'phone': phone,
        'birthDate': birthDate,
        'firstName': firstName ?? '',
        'middleName': middleName ?? '',
        'bmwModel': bmwModel ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // успешно
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ошибка: $e';
    }
  }

  // Вход в систему
  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Проверка подтверждения email
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        return 'Email не подтверждён. Проверьте почту.';
      }

      return null; // успешно
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ошибка: $e';
    }
  }

  // Повторная отправка письма с подтверждением
  Future<String?> resendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return 'Письмо с подтверждением отправлено.';
      }
      return 'Email уже подтверждён или пользователь не найден.';
    } catch (e) {
      return 'Ошибка при повторной отправке: $e';
    }
  }

  // Выход
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Проверка, вошел ли пользователь
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
