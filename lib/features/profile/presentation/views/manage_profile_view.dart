import 'package:flutter/material.dart';
import 'widgets/custom_input_field.dart';
import 'widgets/primary_button.dart';
import 'widgets/profile_avatar.dart';

class ManageProfileView extends StatelessWidget {
  const ManageProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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

              const ProfileAvatar(),

              const SizedBox(height: 16),

              const Text(
                'User Name',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF181D27),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'username@gmail.com',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFABABAB),
                ),
              ),

              const SizedBox(height: 5),

              const CustomInputField(
                label: 'First Name',
                placeholder: 'Mahmoud...',
              ),

              const SizedBox(height: 15),

              const CustomInputField(
                label: 'Last Name',
                placeholder: 'Mohamed...',
              ),

              const SizedBox(height: 15),

              const CustomInputField(
                label: 'Birth Date',
                placeholder: '22-02-2000...',
              ),

              const SizedBox(height: 140),

              PrimaryButton(text: 'Update Profile', onPressed: () {}),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}