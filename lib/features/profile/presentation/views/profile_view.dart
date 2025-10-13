import 'package:flutter/material.dart';
import 'package:planmate_app/features/profile/presentation/views/widgets/profile_avatar.dart';
import 'package:planmate_app/features/profile/presentation/views/widgets/profile_menu_item.dart';
import 'manage_profile_view.dart';
import 'change_password_view.dart';
import 'terms_conditions_view.dart';
import 'support_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D394E),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              const ProfileAvatar(),
              
              const SizedBox(height: 24),
              
              Text(
                'User Name',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D394E),
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 60),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Manage Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageProfileView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileMenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsConditionsView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Support',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        // Add logout logic here
                      },
                      showArrow: false,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}