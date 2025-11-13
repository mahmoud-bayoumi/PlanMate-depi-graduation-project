import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/authentication/bloc/auth_bloc.dart';
import 'package:planmate_app/features/authentication/bloc/auth_event.dart';
import 'package:planmate_app/features/authentication/bloc/auth_state.dart';
import 'package:planmate_app/features/authentication/presentation/view/reset_screen.dart';

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

  // Create testable widget for ResetScreen
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const ResetScreen(),
      ),
    );
  }

  group('ResetScreen Widget Tests', () {
    testWidgets('Test 1: UI Element Presence', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Reset Password'), findsOneWidget);
      expect(
        find.text(
          'Please enter your email address to request a password reset.',
        ),
        findsOneWidget,
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('SEND'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Test 2: Password Reset Event Dispatch', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailField = find.byType(TextFormField);
      await tester.enterText(emailField, 'test@example.com');

      final sendButton = find.text('SEND');
      await tester.tap(sendButton);
      await tester.pump();

      verify(
        () => mockAuthBloc.add(
          any(
            that: isA<AuthResetPassword>().having(
              (e) => e.email,
              'email',
              'test@example.com',
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('Test 3: Button Disabled During Loading', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      final sendButton = find.widgetWithText(ElevatedButton, 'SEND');
      final button = tester.widget<ElevatedButton>(sendButton);

      expect(button.onPressed, isNull);
    });
  });
}
