import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/profile_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService;
  StreamSubscription? _userSubscription;

  ProfileBloc(this._profileService) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<PickAndUploadProfileImage>(_onPickAndUploadProfileImage);
    on<UpdateProfileImageUrl>(_onUpdateProfileImageUrl);
    on<DeleteProfileImage>(_onDeleteProfileImage);
    on<ChangePassword>(_onChangePassword);
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _userSubscription?.cancel();

      _userSubscription = _profileService
          .streamUserData(event.userId)
          .listen((userData) {
        if (userData != null) {
          add(UpdateProfileImageUrl(imageUrl: userData.profileImageUrl ?? ''));
        }
      });

      final user = await _profileService.getUserData(event.userId);
      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        emit(ProfileError(message: 'User not found'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded && currentState is! ProfileUpdateSuccess) {
      emit(ProfileError(message: 'No user data available'));
      return;
    }

    final currentUser = currentState is ProfileLoaded
        ? currentState.user
        : (currentState as ProfileUpdateSuccess).user;

    emit(ProfileUpdating(user: currentUser));

    try {
      final userId = _profileService.currentUserId;
      if (userId == null) {
        emit(ProfileError(
          message: 'User not logged in',
          user: currentUser,
        ));
        return;
      }

      await _profileService.updateUserProfile(
        userId: userId,
        firstName: event.firstName,
        lastName: event.lastName,
        birthDate: event.birthDate,
      );

      final updatedUser = await _profileService.getUserData(userId);
      if (updatedUser != null) {
        emit(ProfileUpdateSuccess(
          user: updatedUser,
          message: 'Profile updated successfully',
        ));
        await Future.delayed(const Duration(milliseconds: 1500));
        emit(ProfileLoaded(user: updatedUser));
      }
    } catch (e) {
      emit(ProfileError(
        message: 'Failed to update profile: $e',
        user: currentUser,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(ProfileLoaded(user: currentUser));
    }
  }

  Future<void> _onPickAndUploadProfileImage(
    PickAndUploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded && currentState is! ProfileUpdateSuccess) {
      emit(ProfileError(message: 'No user data available'));
      return;
    }

    final currentUser = currentState is ProfileLoaded
        ? currentState.user
        : (currentState as ProfileUpdateSuccess).user;

    try {
      final imageFile = event.fromCamera
          ? await _profileService.pickImageFromCamera()
          : await _profileService.pickImageFromGallery();

      if (imageFile == null) {
        return;
      }

      emit(ProfileImageUploading(user: currentUser));

      final userId = _profileService.currentUserId;
      if (userId == null) {
        emit(ProfileError(
          message: 'User not logged in',
          user: currentUser,
        ));
        return;
      }

      final imageUrl = await _profileService.uploadProfileImage(
        userId,
        imageFile,
      );

      await _profileService.updateUserProfile(
        userId: userId,
        profileImageUrl: imageUrl,
      );

      final updatedUser = await _profileService.getUserData(userId);
      if (updatedUser != null) {
        emit(ProfileUpdateSuccess(
          user: updatedUser,
          message: 'Profile image updated successfully',
        ));
        await Future.delayed(const Duration(milliseconds: 1500));
        emit(ProfileLoaded(user: updatedUser));
      }
    } catch (e) {
      emit(ProfileError(
        message: 'Failed to upload image: $e',
        user: currentUser,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(ProfileLoaded(user: currentUser));
    }
  }

  Future<void> _onUpdateProfileImageUrl(
    UpdateProfileImageUrl event,
    Emitter<ProfileState> emit,
  ) async {

    if (state is ProfileLoaded) {
      final currentUser = (state as ProfileLoaded).user;
      if (currentUser.profileImageUrl != event.imageUrl) {
        final updatedUser = currentUser.copyWith(
          profileImageUrl: event.imageUrl.isEmpty ? null : event.imageUrl,
        );
        emit(ProfileLoaded(user: updatedUser));
      }
    }
  }

  Future<void> _onDeleteProfileImage(
    DeleteProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded && currentState is! ProfileUpdateSuccess) {
      emit(ProfileError(message: 'No user data available'));
      return;
    }

    final currentUser = currentState is ProfileLoaded
        ? currentState.user
        : (currentState as ProfileUpdateSuccess).user;

    emit(ProfileImageUploading(user: currentUser));

    try {
      final userId = _profileService.currentUserId;
      if (userId == null) {
        emit(ProfileError(
          message: 'User not logged in',
          user: currentUser,
        ));
        return;
      }

      await _profileService.deleteProfileImage(userId);

      await _profileService.updateUserProfile(
        userId: userId,
        profileImageUrl: '',
      );

      final updatedUser = await _profileService.getUserData(userId);
      if (updatedUser != null) {
        emit(ProfileUpdateSuccess(
          user: updatedUser,
          message: 'Profile image removed',
        ));
        await Future.delayed(const Duration(milliseconds: 1500));
        emit(ProfileLoaded(user: updatedUser));
      }
    } catch (e) {
      emit(ProfileError(
        message: 'Failed to delete image: $e',
        user: currentUser,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(ProfileLoaded(user: currentUser));
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded && currentState is! ProfileUpdateSuccess) {
      emit(ProfileError(message: 'No user data available'));
      return;
    }

    final currentUser = currentState is ProfileLoaded
        ? currentState.user
        : (currentState as ProfileUpdateSuccess).user;

    emit(PasswordChanging(user: currentUser));

    try {
      if (event.currentPassword == event.newPassword) {
        emit(ProfileError(
          message: 'New password cannot be the same as current password',
          user: currentUser,
        ));
        await Future.delayed(const Duration(seconds: 2));
        emit(ProfileLoaded(user: currentUser));
        return;
      }

      if (event.newPassword.length < 6) {
        emit(ProfileError(
          message: 'New password must be at least 6 characters',
          user: currentUser,
        ));
        await Future.delayed(const Duration(seconds: 2));
        emit(ProfileLoaded(user: currentUser));
        return;
      }

      await _profileService.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );

      emit(PasswordChangeSuccess(
        user: currentUser,
        message: 'Password changed successfully',
      ));

      await Future.delayed(const Duration(seconds: 2));
      emit(ProfileLoaded(user: currentUser));
    } catch (e) {
      emit(ProfileError(
        message: e.toString().replaceAll('Exception: ', ''),
        user: currentUser,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(ProfileLoaded(user: currentUser));
    }
  }
}