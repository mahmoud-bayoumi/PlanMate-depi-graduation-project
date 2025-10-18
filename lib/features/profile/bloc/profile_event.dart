import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  final String userId;

  LoadUserProfile({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateUserProfile extends ProfileEvent {
  final String? firstName;
  final String? lastName;
  final String? birthDate;

  UpdateUserProfile({
    this.firstName,
    this.lastName,
    this.birthDate,
  });

  @override
  List<Object?> get props => [firstName, lastName, birthDate];
}

class PickAndUploadProfileImage extends ProfileEvent {
  final bool fromCamera;

  PickAndUploadProfileImage({this.fromCamera = false});

  @override
  List<Object?> get props => [fromCamera];
}

class UpdateProfileImageUrl extends ProfileEvent {
  final String imageUrl;

  UpdateProfileImageUrl({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class DeleteProfileImage extends ProfileEvent {}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}