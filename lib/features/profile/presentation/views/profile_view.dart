import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/bloc/auth_bloc.dart';
import '../../../authentication/bloc/auth_event.dart';
import '../../../authentication/presentation/view/login_screen.dart';
import '../../../home/presentation/view_model/favourite_cubit/favourite_cubit.dart';
import '../../../home/presentation/view_model/favourite_cubit/favourite_state.dart';
import '../../../home/presentation/view_model/get_category_cubit/get_category_cubit.dart';
import '../../../home/presentation/view_model/get_category_cubit/get_category_state.dart';
import '../../../home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import '../../../home/presentation/view_model/user_events_bloc/user_events_state.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_state.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_menu_item.dart';
import 'manage_profile_view.dart';
import 'change_password_view.dart';
import 'terms_conditions_view.dart';
import 'support_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        String userName = 'User Name';
        String? profileImageUrl;

        if (profileState is ProfileLoaded) {
          userName = profileState.user.fullName;
          profileImageUrl = profileState.user.profileImageUrl;
        } else if (profileState is ProfileUpdateSuccess) {
          userName = profileState.user.fullName;
          profileImageUrl = profileState.user.profileImageUrl;
        } else if (profileState is ProfileUpdating) {
          userName = profileState.user.fullName;
          profileImageUrl = profileState.user.profileImageUrl;
        } else if (profileState is ProfileError && profileState.user != null) {
          userName = profileState.user!.fullName;
          profileImageUrl = profileState.user!.profileImageUrl;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D394E),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ProfileAvatar(imageUrl: profileImageUrl),
                  const SizedBox(height: 24),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D394E),
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
                                builder: (context) =>
                                    const ManageProfileView(),
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
                                builder: (context) =>
                                    const ChangePasswordView(),
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
                                builder: (context) =>
                                    const TermsConditionsView(),
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
                          onTap: () async {
                            // Sign out user
                            context.read<AuthBloc>().add(AuthSignOut());

                            // Clear BLoCs data manually (your logic)
                            context.read<UserEventsBloc>().emit(UserEventsInitial());
                            context.read<FavoriteCubit>().emit(FavoriteInitial());
                            context.read<GetCategoryCubit>().emit(GetCategoryInitial());

                            // Optional: clear any saved data if needed
                            // final prefs = await SharedPreferences.getInstance();
                            // await prefs.clear();

                            // Navigate to login screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
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
      },
    );
  }
}
