import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// States (current app status)
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state (app just started)
class AuthInitial extends AuthState {}

// Loading state (during auth process)
class AuthLoading extends AuthState {}

// Authenticated state (user is logged in)
class AuthAuthenticated extends AuthState {
  final User? user;

  AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

// Unauthenticated state (user is not logged in or logged out)
class AuthUnauthenticated extends AuthState {}

// Error state (auth process failed)
class AuthError extends AuthState {
  final String errorMessage;

  AuthError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
