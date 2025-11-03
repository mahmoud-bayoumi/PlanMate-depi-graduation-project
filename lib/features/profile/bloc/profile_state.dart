import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileUpdating extends ProfileState {
  final UserModel user;

  ProfileUpdating({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel user;
  final String message;

  ProfileUpdateSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

class ProfileImageUploading extends ProfileState {
  final UserModel user;

  ProfileImageUploading({required this.user});

  @override
  List<Object?> get props => [user];
}

class PasswordChanging extends ProfileState {
  final UserModel user;

  PasswordChanging({required this.user});

  @override
  List<Object?> get props => [user];
}

class PasswordChangeSuccess extends ProfileState {
  final UserModel user;
  final String message;

  PasswordChangeSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

class ProfileError extends ProfileState {
  final String message;
  final UserModel? user;

  ProfileError({required this.message, this.user});

  @override
  List<Object?> get props => [message, user];
}