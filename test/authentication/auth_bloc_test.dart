import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/authentication/bloc/auth_bloc.dart';
import 'package:planmate_app/features/authentication/bloc/auth_event.dart';
import 'package:planmate_app/features/authentication/bloc/auth_state.dart';
import 'package:planmate_app/features/authentication/services/auth_service.dart';

// Mock Classes
// Allow us to simulate Firebase behavior
class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  late MockAuthService mockAuthService;
  late StreamController<User?> authStateController;

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
  });

  // Set up mocktail and StreamController before each test (isolation)
  setUp(() {
    mockAuthService = MockAuthService();
    authStateController = StreamController<User?>.broadcast();
    when(
      () => mockAuthService.authStateChanges(),
    ).thenAnswer((_) => authStateController.stream);
  });

  // Clean up after each test
  tearDown(() {
    authStateController.close();
  });

  group('AuthBloc Essential Tests', () {
    test('Test 1: Verify Initial State', () {
      final authBloc = AuthBloc(mockAuthService);
      expect(authBloc.state, equals(AuthInitial()));
      authBloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'Test 2: App Startup with Authenticated User',
      build: () {
        final mockUser = MockUser();
        when(() => mockAuthService.getCurrentUser()).thenReturn(mockUser);
        return AuthBloc(mockAuthService);
      },
      act: (bloc) => bloc.add(AuthStarted()),
      expect: () => [isA<AuthAuthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'Test 3: App Startup without User',
      build: () {
        when(() => mockAuthService.getCurrentUser()).thenReturn(null);
        return AuthBloc(mockAuthService);
      },
      act: (bloc) => bloc.add(AuthStarted()),
      expect: () => [isA<AuthUnauthenticated>()],
    );

    blocTest<AuthBloc, AuthState>(
      'Test 4: Successful Email Sign-In Flow',
      build: () {
        final mockUser = MockUser();
        when(
          () => mockAuthService.signInWithEmail(any(), any()),
        ).thenAnswer((_) async => mockUser);
        when(() => mockAuthService.getCurrentUser()).thenReturn(null);
        return AuthBloc(mockAuthService);
      },
      act: (bloc) async {
        final mockUser = MockUser();
        bloc.add(AuthStarted());
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(
          AuthSignInWithEmail(
            email: 'test@example.com',
            password: 'password123',
          ),
        );
        await Future.delayed(const Duration(milliseconds: 50));
        authStateController.add(mockUser);
      },
      expect: () => [
        isA<AuthUnauthenticated>(),
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Test 5: Failed Email Sign-In',
      build: () {
        when(
          () => mockAuthService.signInWithEmail(any(), any()),
        ).thenThrow(Exception('Invalid credentials'));
        when(() => mockAuthService.getCurrentUser()).thenReturn(null);
        return AuthBloc(mockAuthService);
      },
      act: (bloc) => bloc.add(
        AuthSignInWithEmail(email: 'test@example.com', password: 'wrong'),
      ),
      wait: const Duration(milliseconds: 200),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Test 6: Successful User Registration',
      build: () {
        final mockUser = MockUser();
        when(
          () => mockAuthService.signUpWithEmail(
            any(),
            any(),
            any(),
            any(),
            any(),
          ),
        ).thenAnswer((_) async => mockUser);
        when(() => mockAuthService.getCurrentUser()).thenReturn(null);
        return AuthBloc(mockAuthService);
      },
      act: (bloc) async {
        final mockUser = MockUser();
        bloc.add(AuthStarted());
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(
          AuthSignUpWithEmail(
            email: 'new@example.com',
            password: 'password123',
            firstName: 'John',
            lastName: 'Doe',
            birthDate: '1990-01-01',
          ),
        );
        await Future.delayed(const Duration(milliseconds: 50));
        authStateController.add(mockUser);
      },
      expect: () => [
        isA<AuthUnauthenticated>(),
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Test 7: User Sign-Out Flow',
      build: () {
        final mockUser = MockUser();
        when(() => mockAuthService.signOut()).thenAnswer((_) async => {});
        when(() => mockAuthService.getCurrentUser()).thenReturn(mockUser);
        return AuthBloc(mockAuthService);
      },
      act: (bloc) async {
        bloc.add(AuthStarted());
        await Future.delayed(const Duration(milliseconds: 50));
        bloc.add(AuthSignOut());
        await Future.delayed(const Duration(milliseconds: 50));
        authStateController.add(null);
      },
      expect: () => [
        isA<AuthAuthenticated>(),
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );
  });
}
