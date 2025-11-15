import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/profile/bloc/profile_bloc.dart';
import 'package:planmate_app/features/profile/bloc/profile_event.dart';
import 'package:planmate_app/features/profile/bloc/profile_state.dart';
import 'package:planmate_app/features/profile/models/user_model.dart';
import 'package:planmate_app/features/profile/services/profile_service.dart';

class MockProfileService extends Mock implements ProfileService {}

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;
    late MockProfileService mockProfileService;

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
      mockProfileService = MockProfileService();
      profileBloc = ProfileBloc(mockProfileService);
    });

    tearDown(() {
      profileBloc.close();
    });

    // TEST 1: Initial state is ProfileInitial
    test('initial state should be ProfileInitial', () {
      expect(profileBloc.state, ProfileInitial());
    });

    // TEST 2: LoadUserProfile event - Success scenario
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when LoadUserProfile succeeds',
      build: () {
        when(() => mockProfileService.getUserData('user1'))
            .thenAnswer((_) async => testUser);
        when(() => mockProfileService.streamUserData('user1'))
            .thenAnswer((_) => const Stream.empty());
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadUserProfile(userId: 'user1')),
      expect: () => [
        ProfileLoading(),
        ProfileLoaded(user: testUser),
      ],
      verify: (_) {
        verify(() => mockProfileService.getUserData('user1')).called(1);
      },
    );

    // TEST 3: LoadUserProfile event - Failure scenario
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when LoadUserProfile fails',
      build: () {
        when(() => mockProfileService.getUserData('user1'))
            .thenThrow(Exception('Failed to load user'));
        when(() => mockProfileService.streamUserData('user1'))
            .thenAnswer((_) => const Stream.empty());
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadUserProfile(userId: 'user1')),
      expect: () => [
        ProfileLoading(),
        isA<ProfileError>().having(
          (state) => state.message,
          'error message',
          contains('Exception: Failed to load user'),
        ),
      ],
    );

    // TEST 4: UpdateUserProfile event - Success scenario
    blocTest<ProfileBloc, ProfileState>(
      'emits correct states when UpdateUserProfile succeeds',
      build: () {
        when(() => mockProfileService.currentUserId).thenReturn('user1');
        when(() => mockProfileService.updateUserProfile(
              userId: 'user1',
              firstName: 'f2',
              lastName: 'l2',
            )).thenAnswer((_) async => {});

        final updatedUser = testUser.copyWith(
          firstName: 'f2',
          lastName: 'l2',
        );

        when(() => mockProfileService.getUserData('user1'))
            .thenAnswer((_) async => updatedUser);

        return profileBloc;
      },
      seed: () => ProfileLoaded(user: testUser),
      act: (bloc) => bloc.add(UpdateUserProfile(
        firstName: 'f2',
        lastName: 'l2',
      )),
      expect: () => [
        ProfileUpdating(user: testUser),
        isA<ProfileUpdateSuccess>().having(
          (state) => state.user.firstName,
          'firstName',
          'f2',
        ),
        isA<ProfileLoaded>().having(
          (state) => state.user.firstName,
          'firstName',
          'f2',
        ),
      ],
      wait: const Duration(seconds: 3),
    );

    // TEST 5: UpdateUserProfile event - Failure scenario
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileUpdating, ProfileError, ProfileLoaded] when update fails',
      build: () {
        when(() => mockProfileService.currentUserId).thenReturn('user1');
        when(() => mockProfileService.updateUserProfile(
              userId: any(named: 'userId'),
              firstName: any(named: 'firstName'),
            )).thenThrow(Exception('Update failed'));

        return profileBloc;
      },
      seed: () => ProfileLoaded(user: testUser),
      act: (bloc) => bloc.add(UpdateUserProfile(firstName: 'f3')),
      expect: () => [
        ProfileUpdating(user: testUser),
        isA<ProfileError>().having(
          (state) => state.message,
          'error message',
          contains('Update failed'),
        ),
        ProfileLoaded(user: testUser),
      ],
      wait: const Duration(seconds: 3),
    );

    // TEST 6: ChangePassword event - Success with valid passwords
    blocTest<ProfileBloc, ProfileState>(
      'emits success states when password change succeeds',
      build: () {
        when(() => mockProfileService.changePassword(
              currentPassword: 'oldPass1',
              newPassword: 'newPass2',
            )).thenAnswer((_) async => {});

        return profileBloc;
      },
      seed: () => ProfileLoaded(user: testUser),
      act: (bloc) => bloc.add(ChangePassword(
        currentPassword: 'oldPass1',
        newPassword: 'newPass2',
      )),
      expect: () => [
        PasswordChanging(user: testUser),
        isA<PasswordChangeSuccess>().having(
          (state) => state.message,
          'success message',
          'Password changed successfully',
        ),
        ProfileLoaded(user: testUser),
      ],
      wait: const Duration(seconds: 3),
    );

    // TEST 7: ChangePassword - Reject same password
    blocTest<ProfileBloc, ProfileState>(
      'emits error when new password is same as current',
      build: () => profileBloc,
      seed: () => ProfileLoaded(user: testUser),
      act: (bloc) => bloc.add(ChangePassword(
        currentPassword: 'samePass1',
        newPassword: 'samePass1',
      )),
      expect: () => [
        PasswordChanging(user: testUser),
        isA<ProfileError>().having(
          (state) => state.message,
          'error message',
          contains('cannot be the same'),
        ),
        ProfileLoaded(user: testUser),
      ],
      wait: const Duration(seconds: 3),
    );

    // TEST 8: ChangePassword - Reject short password
    blocTest<ProfileBloc, ProfileState>(
      'emits error when new password is too short',
      build: () => profileBloc,
      seed: () => ProfileLoaded(user: testUser),
      act: (bloc) => bloc.add(ChangePassword(
        currentPassword: 'oldPass1',
        newPassword: '12345',
      )),
      expect: () => [
        PasswordChanging(user: testUser),
        isA<ProfileError>().having(
          (state) => state.message,
          'error message',
          contains('at least 6 characters'),
        ),
        ProfileLoaded(user: testUser),
      ],
      wait: const Duration(seconds: 3),
    );

    // TEST 9: ChangePassword - Service error
    blocTest<ProfileBloc, ProfileState>(
      'emits error when password change service fails',
      build: () {
        when(() => mockProfileService.changePassword(
              currentPassword: 'oldPass1',
              newPassword: 'newPass2',
            )).thenThrow(Exception('Wrong password'));

        return profileBloc;
      },
      seed: () => ProfileLoaded(user: testUser),
      act: (bloc) => bloc.add(ChangePassword(
        currentPassword: 'oldPass1',
        newPassword: 'newPass2',
      )),
      expect: () => [
        PasswordChanging(user: testUser),
        isA<ProfileError>().having(
          (state) => state.message,
          'error message',
          contains('Wrong password'),
        ),
        ProfileLoaded(user: testUser),
      ],
      wait: const Duration(seconds: 3),
    );

    // TEST 10: Multiple events in sequence
    blocTest<ProfileBloc, ProfileState>(
      'handles multiple LoadUserProfile events correctly',
      build: () {
        when(() => mockProfileService.getUserData('user1'))
            .thenAnswer((_) async => testUser);
        when(() => mockProfileService.streamUserData('user1'))
            .thenAnswer((_) => const Stream.empty());

        return profileBloc;
      },
      act: (bloc) async {
        bloc.add(LoadUserProfile(userId: 'user1'));
        await Future.delayed(const Duration(milliseconds: 300));
        bloc.add(LoadUserProfile(userId: 'user1'));
      },
      expect: () => [
        ProfileLoading(),
        ProfileLoaded(user: testUser),
        ProfileLoading(),
        ProfileLoaded(user: testUser),
      ],
      wait: const Duration(seconds: 1),
    );
  });
}