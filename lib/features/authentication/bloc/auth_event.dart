import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Events (user actions)
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// When the app starts
class AuthStarted extends AuthEvent {}

// When user logs in/out
class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged({required this.user});

  @override
  List<Object?> get props => [user];
}

// When user tries to sign in with email and password
class AuthSignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  AuthSignInWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// When user tries to sign up with email and password
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

// When user tries to sign in with Google
class AuthSignInWithGoogle extends AuthEvent {}

// When user requests a password reset
class AuthResetPassword extends AuthEvent {
  final String email;

  AuthResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

// When user signs out
class AuthSignOut extends AuthEvent {}