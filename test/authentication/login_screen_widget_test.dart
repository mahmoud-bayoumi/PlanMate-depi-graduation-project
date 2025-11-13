import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/authentication/bloc/auth_bloc.dart';
import 'package:planmate_app/features/authentication/bloc/auth_event.dart';
import 'package:planmate_app/features/authentication/bloc/auth_state.dart';
import 'package:planmate_app/features/authentication/presentation/view/login_screen.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_bloc.dart';

// Mock BLoC classes for testing UI in isolation
class MockAuthBloc extends Mock implements AuthBloc {}

class MockUserEventsBloc extends Mock implements UserEventsBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockUserEventsBloc mockUserEventsBloc;

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  // Set up mocktail and StreamController before each test (isolation)
  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockUserEventsBloc = MockUserEventsBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(
      () => mockAuthBloc.stream,
    ).thenAnswer((_) => Stream.fromIterable([AuthInitial()]));
  });

  // Create testable widget for LoginScreen
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<UserEventsBloc>.value(value: mockUserEventsBloc),
        ],
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('Test 1: UI Element Presence', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Remember me'), findsOneWidget);
      expect(find.text('Forgot Password ?'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Or login with'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('Test 2: Empty Fields Validation', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final loginButton = find.text('Log In');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter both email and password'), findsOneWidget);
    });

    testWidgets('Test 3: Password Length Validation', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, '12345');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('Test 4: Successful Login Event Dispatch', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final loginButton = find.text('Log In');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(
        () => mockAuthBloc.add(
          any(
            that: isA<AuthSignInWithEmail>()
                .having((e) => e.email, 'email', 'test@example.com')
                .having((e) => e.password, 'password', 'password123'),
          ),
        ),
      ).called(1);
    });

    testWidgets('Test 5: Loading State Display', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());
      when(
        () => mockAuthBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([AuthLoading()]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
