import 'package:flutter/material.dart';
import 'package:planmate/screens/change_password.dart';
import 'package:planmate/screens/manage_profile.dart';
import 'package:planmate/screens/support.dart';
import 'package:planmate/screens/terms_conditions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
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
                  
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4D4F5),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: const Color(0xFF0601B4),
                      ),
                    ),
                  ),
                  
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
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Manage Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ManageProfileScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangePasswordScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsConditionsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Support',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SupportScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: () {},
                          showArrow: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E2E2),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.black87,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showArrow)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.black54,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, false),
          _buildNavItem(Icons.star_outline, false),
          _buildNavItem(Icons.auto_fix_high_outlined, false),
          _buildNavItem(Icons.person, true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        size: 28,
        color: isActive ? const Color(0xFF1D61E7) : Colors.grey[400],
      ),
    );
  }
}