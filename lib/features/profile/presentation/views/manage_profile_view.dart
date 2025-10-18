import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';
import '../../bloc/profile_state.dart';
import 'widgets/custom_input_field.dart';
import 'widgets/date_input_field.dart';
import 'widgets/primary_button.dart';
import 'widgets/profile_avatar.dart';

class ManageProfileView extends StatefulWidget {
  const ManageProfileView({super.key});

  @override
  State<ManageProfileView> createState() => _ManageProfileViewState();
}

class _ManageProfileViewState extends State<ManageProfileView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog(BuildContext context) {
    final hasImage = context.read<ProfileBloc>().state is ProfileLoaded &&
        (context.read<ProfileBloc>().state as ProfileLoaded).user.profileImageUrl != null &&
        (context.read<ProfileBloc>().state as ProfileLoaded).user.profileImageUrl!.isNotEmpty;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Profile Photo',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF1D61E7)),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(fontFamily: 'PlusJakartaSans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                        PickAndUploadProfileImage(fromCamera: false),
                      );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF1D61E7)),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(fontFamily: 'PlusJakartaSans'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                        PickAndUploadProfileImage(fromCamera: true),
                      );
                },
              ),
              if (hasImage)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ProfileBloc>().add(DeleteProfileImage());
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleUpdate(BuildContext context) {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final birthDate = birthDateController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || birthDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ProfileBloc>().add(
          UpdateUserProfile(
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDate,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded && firstNameController.text.isEmpty) {
          firstNameController.text = state.user.firstName;
          lastNameController.text = state.user.lastName;
          birthDateController.text = state.user.birthDate;
        }

        String userName = 'User Name';
        String email = 'username@gmail.com';
        String? profileImageUrl;
        bool isLoading = false;
        bool isImageUploading = false;

        if (state is ProfileLoaded) {
          userName = state.user.fullName;
          email = state.user.email;
          profileImageUrl = state.user.profileImageUrl;
        } else if (state is ProfileUpdateSuccess) {
          userName = state.user.fullName;
          email = state.user.email;
          profileImageUrl = state.user.profileImageUrl;
        } else if (state is ProfileUpdating) {
          userName = state.user.fullName;
          email = state.user.email;
          profileImageUrl = state.user.profileImageUrl;
          isLoading = true;
        } else if (state is ProfileImageUploading) {
          userName = state.user.fullName;
          email = state.user.email;
          profileImageUrl = state.user.profileImageUrl;
          isImageUploading = true;
        } else if (state is ProfileError && state.user != null) {
          userName = state.user!.fullName;
          email = state.user!.email;
          profileImageUrl = state.user!.profileImageUrl;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F5F5),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Manage Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF181D27),
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Stack(
                    children: [
                      ProfileAvatar(
                        imageUrl: profileImageUrl,
                        showEditIcon: true,
                        onTap: isImageUploading
                            ? null
                            : () => _showImageSourceDialog(context),
                      ),
                      if (isImageUploading)
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tap to change photo',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    userName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF181D27),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFABABAB),
                    ),
                  ),

                  const SizedBox(height: 5),

                  CustomInputField(
                    label: 'First Name',
                    placeholder: 'Mahmoud...',
                    controller: firstNameController,
                  ),

                  const SizedBox(height: 15),

                  CustomInputField(
                    label: 'Last Name',
                    placeholder: 'Mohamed...',
                    controller: lastNameController,
                  ),

                  const SizedBox(height: 15),

                  DateInputField(
                    label: 'Birth Date',
                    placeholder: '22-02-2000...',
                    controller: birthDateController,
                  ),

                  const SizedBox(height: 140),

                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : PrimaryButton(
                          text: 'Update Profile',
                          onPressed: () => _handleUpdate(context),
                        ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}