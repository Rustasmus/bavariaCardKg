import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;

  AuthService() {
    // Слушаем изменения авторизации
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// Поток изменений пользователя (для StreamBuilder и Consumer)
  Stream<User?> get userChanges => _auth.authStateChanges();

  /// Проверка — вошёл ли пользователь
  bool isLoggedIn() => _auth.currentUser != null;

  /// Текущий пользователь
  User? get currentUser => _currentUser;

  /// Получить профиль пользователя из Firestore по UID
  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      debugPrint('Ошибка получения профиля: $e');
      return null;
    }
  }

  /// Регистрация нового пользователя
  Future<String?> registerUser({
    required String email,
    required String password,
    required String phone,
    required String birthDate,
    required String firstName,
    required String middleName,
    required String bmwModel,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();

      // Сохраняем данные пользователя в Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'phone': phone,
        'birthDate': birthDate,
        'firstName': firstName,
        'middleName': middleName,
        'bmwModel': bmwModel,
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ошибка: $e';
    }
  }

  /// Авторизация пользователя
  Future<String?> loginUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        return 'Email не подтверждён. Проверьте почту.';
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ошибка: $e';
    }
  }

  /// Повторная отправка письма для подтверждения email
  Future<String?> resendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return 'Письмо с подтверждением отправлено.';
      }
      return 'Email уже подтверждён или пользователь не найден.';
    } catch (e) {
      return 'Ошибка при повторной отправке: $e';
    }
  }

  /// Выход из аккаунта
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  /// Получение текущего пользователя вручную
  User? getCurrentUser() => _auth.currentUser;

  /// Добавление записи для пользователя (например, заказ/история)
  Future<String?> addUserRecord({
    required String userId,
    required String workmanId,
    required DateTime date,
    required String order,
    double? amount,
    double? bonus,
  }) async {
    try {
      final data = <String, dynamic>{
        'date': date,
        'order': order,
        'workman_id': workmanId,
      };

      if (amount != null) data['amount'] = amount;
      if (bonus != null) data['bonus'] = bonus;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('records')
          .add(data);

      return null;
    } catch (e) {
      return 'Ошибка при добавлении записи: $e';
    }
  }
}
