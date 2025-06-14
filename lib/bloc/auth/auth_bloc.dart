import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthBloc({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(AuthInitial()) {
    on<AuthStarted>((event, emit) async {
      emit(AuthLoading());
      _auth.authStateChanges().listen((user) {
        add(_UserChanged(user));
      });
      add(_UserChanged(_auth.currentUser));
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        // После логина поток вызовет _UserChanged
      } catch (e) {
        emit(AuthError('Ошибка входа: $e'));
      }
    });

    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        await userCredential.user!.sendEmailVerification();

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': event.email,
          'phone': event.phone,
          'birthDate': event.birthDate,
          'firstName': event.firstName,
          'middleName': event.middleName,
          'bmwModel': event.bmwModel,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _auth.signOut();
        emit(AuthRegistered());
        emit(AuthGuest());
      } catch (e) {
        emit(AuthError('Ошибка регистрации: $e'));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await _auth.signOut();
      emit(AuthGuest());
    });

    on<_UserChanged>(_onUserChanged);
  }

  Future<void> _onUserChanged(_UserChanged event, Emitter<AuthState> emit) async {
    final user = event.user;
    if (user == null) {
      emit(AuthGuest());
      return;
    }
    emit(AuthLoading());
    try {
      // 1. Читаем документ workmans/MOsntYo03RweD3Iqc8Uq
      final docSnap = await _firestore.collection('workmans').doc('MOsntYo03RweD3Iqc8Uq').get();

      if (docSnap.exists) {
        final data = docSnap.data() ?? {};
        bool found = false;
        for (final entry in data.entries) {
          final value = entry.value;
          final key = (entry.key).toString().trim().toLowerCase();
          if (value == user.email) {
            // final key = (value['key'] ?? '').toString().trim().toLowerCase();
            if (key == 'smm') {
              emit(AuthSmm(user));
            } else {
              emit(AuthWorkman(user));
            }
            found = true;
            break;
          }
        }
        if (!found) {
          emit(AuthUser(user));
        }
        return;
      }
      // Если документа нет — считаем обычным юзером
      emit(AuthUser(user));
    } catch (e) {
      emit(AuthError('Ошибка аутентификации: $e'));
    }
  }
}

// Внутренний event для изменения пользователя (чтобы не торчал наружу)
class _UserChanged extends AuthEvent {
  final User? user;
  _UserChanged(this.user);

  @override
  List<Object?> get props => [user];
}
