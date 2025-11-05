import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authUser;

  AuthBloc(this._authService) : super(AuthInitial()) {
    // Event handlers for each authentication action
    on<AuthStarted>(onStarted);
    on<AuthUserChanged>(onUserChanged);
    on<AuthSignInWithEmail>(onSignInEmail);
    on<AuthSignUpWithEmail>(onSignUpEmail);
    on<AuthSignInWithGoogle>(onSignInGoogle);
    on<AuthResetPassword>(onResetPassword);
    on<AuthSignOut>(onSignOut);
  }

  Future<void> onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    await _authUser?.cancel();

    // Listen for login or logout events
    _authUser = _authService.authStateChanges().listen((userData) {
      add(AuthUserChanged(user: userData));
    });

    // Check if user already logged in
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      emit(AuthAuthenticated(user: currentUser));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authUser?.cancel(); // Cancel auth stream
    return super.close();
  }

  // Check if user is present or not (authenticated or unauthenticated)
  Future<void> onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user == null) {
      emit(AuthUnauthenticated());
    } else {
      emit(AuthAuthenticated(user: event.user!));
    }
  }

  // Sign in with email and password
  Future<void> onSignInEmail(
    AuthSignInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.signInWithEmail(event.email, event.password);
    } catch (caughtError) {
      String errorMessage = caughtError.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      emit(AuthError(errorMessage: errorMessage));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthUnauthenticated());
    }
  }

  // Sign up with email and password
  Future<void> onSignUpEmail(
    AuthSignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.signUpWithEmail(
        event.email,
        event.password,
        event.firstName,
        event.lastName,
        event.birthDate,
      );
    } catch (caughtError) {
      String errorMessage = caughtError.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      emit(AuthError(errorMessage: errorMessage));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthUnauthenticated());
    }
  }

  // Sign in with Google
  Future<void> onSignInGoogle(
    AuthSignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.signInWithGoogle();
    } catch (caughtError) {
      String errorMessage = caughtError.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      emit(AuthError(errorMessage: errorMessage));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthUnauthenticated());
    }
  }

  // Reset password
  Future<void> onResetPassword(
    AuthResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.resetPassword(event.email);
      emit(AuthUnauthenticated());
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      emit(AuthError(errorMessage: errorMessage));
    }
  }

  // Sign out
  Future<void> onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await _authService.signOut();
    } catch (caughtError) {
      String errorMessage = caughtError.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      emit(AuthError(errorMessage: errorMessage));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(AuthUnauthenticated());
    }
  }
}