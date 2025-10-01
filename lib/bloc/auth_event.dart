import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

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

  AuthSignUpWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthSignOut extends AuthEvent {}
