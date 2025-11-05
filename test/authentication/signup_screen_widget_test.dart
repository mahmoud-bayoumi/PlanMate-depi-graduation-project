import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/authentication/bloc/auth_bloc.dart';
import 'package:planmate_app/features/authentication/bloc/auth_event.dart';
import 'package:planmate_app/features/authentication/bloc/auth_state.dart';
import 'package:planmate_app/features/authentication/presentation/view/signup_screen.dart';

// Mock BLoC classes for testing UI in isolation
class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late MockAuthBloc mockAuthBloc;

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  // Set up mocktail and StreamController before each test (isolation)
  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(
      () => mockAuthBloc.stream,
    ).thenAnswer((_) => Stream.fromIterable([AuthInitial()]));
  });

  // Create testable widget for SignUpScreen
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const SignUpScreen(),
      ),
    );
  }

  group('SignUpScreen Widget Tests', () {
    testWidgets('Test 1: UI Element Presence', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
    });

    testWidgets('Test 2: Empty Fields Validation', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final registerButton = find.text('Register');
      await tester.tap(registerButton);
      await tester.pump();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('Test 3: Password Length Validation', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John');
      await tester.enterText(textFields.at(1), 'Doe');
      await tester.enterText(textFields.at(2), 'john@example.com');
      await tester.enterText(textFields.at(3), '12345');

      final registerButton = find.text('Register');
      await tester.tap(registerButton);
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('Test 4: Successful Registration Event Dispatch', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John');
      await tester.enterText(textFields.at(1), 'Doe');
      await tester.enterText(textFields.at(2), 'john@example.com');
      await tester.enterText(textFields.at(3), 'password123');

      final registerButton = find.text('Register');
      await tester.tap(registerButton);
      await tester.pump();

      verify(
        () => mockAuthBloc.add(
          any(
            that: isA<AuthSignUpWithEmail>()
                .having((e) => e.email, 'email', 'john@example.com')
                .having((e) => e.password, 'password', 'password123')
                .having((e) => e.firstName, 'firstName', 'John')
                .having((e) => e.lastName, 'lastName', 'Doe'),
          ),
        ),
      ).called(1);
    });

    testWidgets('Test 5: Button Disabled During Loading', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      final button = tester.widget<ElevatedButton>(registerButton);

      expect(button.onPressed, isNull);
    });
  });
}