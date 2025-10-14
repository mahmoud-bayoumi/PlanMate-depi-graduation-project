import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthSignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  AuthSignInWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String birthDate;

  AuthSignUpWithEmail({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, birthDate];
}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthResetPassword extends AuthEvent {
  final String email;

  AuthResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthSignOut extends AuthEvent {}
