import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/profile/bloc/profile_bloc.dart';
import 'package:planmate_app/features/profile/bloc/profile_event.dart';
import 'package:planmate_app/features/profile/bloc/profile_state.dart';
import 'package:planmate_app/features/profile/models/user_model.dart';
import 'package:planmate_app/features/profile/presentation/views/change_password_view.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

class FakeChangePassword extends Fake implements ChangePassword {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChangePassword());
  });

  group('ChangePasswordView Widget Tests', () {
    late MockProfileBloc mockProfileBloc;

    // Sample test data
    final testUser = UserModel(
      userId: 'user1',
      firstName: 'f1',
      lastName: 'l1',
      email: 'user1@example.com',
      birthDate: '01-01-1990',
      profileImageUrl: null,
    );

    setUp(() {
      mockProfileBloc = MockProfileBloc();
      when(() => mockProfileBloc.state).thenReturn(ProfileLoaded(user: testUser));
      when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.value(ProfileLoaded(user: testUser)));
      when(() => mockProfileBloc.close()).thenAnswer((_) async {});
    });

    Widget createWidgetUnderTest() {
      return BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const MaterialApp(
          home: ChangePasswordView(),
        ),
      );
    }

    // TEST 1: Verify all UI elements are rendered correctly
    testWidgets('should render ChangePasswordView with all password fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsNWidgets(2));
      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm New Password'), findsOneWidget);
    });

    // TEST 2: Verify password fields are obscured by default for security
    testWidgets('should obscure all password fields by default', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      for (final field in textFields) {
        expect(field.obscureText, true);
      }
    });

    // TEST 3: Verify visibility toggle works for current password field
    testWidgets('should toggle current password visibility when icon is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final visibilityIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityIcons, findsNWidgets(3));

      await tester.tap(visibilityIcons.first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    // TEST 4: Verify user can input current password
    testWidgets('should allow entering text in current password field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final currentPasswordField = find.byType(TextField).first;
      await tester.enterText(currentPasswordField, 'oldPassword123');
      await tester.pump();

      final textField = tester.widget<TextField>(currentPasswordField);
      expect(textField.controller?.text, 'oldPassword123');
    });

    // TEST 5: Verify user can input new password
    testWidgets('should allow entering text in new password field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final newPasswordField = find.byType(TextField).at(1);
      await tester.enterText(newPasswordField, 'newPassword456');
      await tester.pump();

      final textField = tester.widget<TextField>(newPasswordField);
      expect(textField.controller?.text, 'newPassword456');
    });

    // TEST 6: Verify user can input password confirmation
    testWidgets('should allow entering text in confirm password field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final confirmPasswordField = find.byType(TextField).at(2);
      await tester.enterText(confirmPasswordField, 'confirmPassword789');
      await tester.pump();

      final textField = tester.widget<TextField>(confirmPasswordField);
      expect(textField.controller?.text, 'confirmPassword789');
    });

    // TEST 7: Verify error feedback is shown to user
    testWidgets('should show error snackbar on ProfileError', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        ProfileError(message: 'Current password is incorrect', user: testUser),
      );
      when(() => mockProfileBloc.stream).thenAnswer(
        (_) => Stream.value(ProfileError(message: 'Current password is incorrect', user: testUser)),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Current password is incorrect'), findsOneWidget);
    });

    // TEST 8: Verify navigation back button works correctly
    testWidgets('should navigate back when back button is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Current Password'), findsNothing);
    });

    // TEST 9: Verify screen is scrollable for smaller devices
    testWidgets('should be scrollable', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}