import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  AuthLoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String phone;
  final String birthDate;
  final String firstName;
  final String middleName;
  final String bmwModel;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.phone,
    required this.birthDate,
    required this.firstName,
    required this.middleName,
    required this.bmwModel,
  });

  @override
  List<Object?> get props =>
      [email, password, phone, birthDate, firstName, middleName, bmwModel];
}

class AuthLoggedOut extends AuthEvent {}
