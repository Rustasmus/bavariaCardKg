import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthRegistered extends AuthState {}

class AuthLoading extends AuthState {}

class AuthGuest extends AuthState {}

class AuthUser extends AuthState {
  final User user;
  AuthUser(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthWorkman extends AuthState {
  final User user;
  AuthWorkman(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthSmm extends AuthState {
  final User user;
  AuthSmm(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
