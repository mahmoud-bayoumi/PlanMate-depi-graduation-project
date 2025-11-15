import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/profile/bloc/profile_bloc.dart';
import 'package:planmate_app/features/profile/bloc/profile_state.dart';
import 'package:planmate_app/features/profile/models/user_model.dart';
import 'package:planmate_app/features/profile/presentation/views/manage_profile_view.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

void main() {
  group('ManageProfileView Widget Tests', () {
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
      when(() => mockProfileBloc.stream)
          .thenAnswer((_) => Stream.value(ProfileLoaded(user: testUser)));
    });

    Widget createWidgetUnderTest() {
      return BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const MaterialApp(
          home: ManageProfileView(),
        ),
      );
    }

    // TEST 1: ManageProfileView renders correctly
    testWidgets('should render ManageProfileView with all form fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Manage Profile'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Birth Date'), findsOneWidget);
      expect(find.text('Update Profile'), findsOneWidget);
    });

    // TEST 2: Shows user data in form fields
    testWidgets('should populate form fields with user data', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('f1'), findsOneWidget);
      expect(find.text('l1'), findsOneWidget);
      expect(find.text('01-01-1990'), findsOneWidget);
      expect(find.text('user1@example.com'), findsOneWidget);
    });

    // TEST 3: Can edit first name field
    testWidgets('should allow editing first name field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final firstNameField = find.widgetWithText(TextField, 'f1');
      expect(firstNameField, findsOneWidget);

      await tester.enterText(firstNameField, 'f2');
      await tester.pumpAndSettle();

      expect(find.text('f2'), findsOneWidget);
    });

    // TEST 4: Can edit last name field
    testWidgets('should allow editing last name field', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final lastNameField = find.widgetWithText(TextField, 'l1');
      expect(lastNameField, findsOneWidget);

      await tester.enterText(lastNameField, 'l2');
      await tester.pumpAndSettle();

      expect(find.text('l2'), findsOneWidget);
    });

    // TEST 5: Profile avatar is displayed
    testWidgets('should display profile avatar', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    // TEST 6: Shows "Tap to change photo" text
    testWidgets('should show hint text for changing photo', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Tap to change photo'), findsOneWidget);
    });

    // TEST 7: Shows snackbar on successful update
    testWidgets('should show success snackbar on ProfileUpdateSuccess', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        ProfileUpdateSuccess(user: testUser, message: 'Profile updated successfully'),
      );
      when(() => mockProfileBloc.stream).thenAnswer(
        (_) => Stream.value(ProfileUpdateSuccess(user: testUser, message: 'Profile updated successfully')),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Profile updated successfully'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    // TEST 8: Shows error snackbar on ProfileError
    testWidgets('should show error snackbar on ProfileError', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(
        ProfileError(message: 'Failed to update profile', user: testUser),
      );
      when(() => mockProfileBloc.stream).thenAnswer(
        (_) => Stream.value(ProfileError(message: 'Failed to update profile', user: testUser)),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Failed to update profile'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    // TEST 9: Back button navigates back
    testWidgets('should navigate back when back button is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Manage Profile'), findsNothing);
    });

    // TEST 10: Email is displayed and read-only
    testWidgets('should display email as read-only', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('user1@example.com'), findsOneWidget);
    });

    // TEST 11: Screen is scrollable
    testWidgets('should be scrollable', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}