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

    _authUser = _authService.authStateChanges().listen((userData) {
      add(AuthUserChanged(user: userData));
    });

    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      emit(AuthAuthenticated(user: currentUser));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authUser?.cancel();
    return super.close();
  }

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
