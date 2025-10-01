import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planmate_app/bloc/auth_bloc.dart';
import 'package:planmate_app/bloc/auth_event.dart';
import 'package:planmate_app/bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Color(0xFFF7F8FA),
          appBar: AppBar(
            backgroundColor: Color(0xFFF7F8FA),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C1E)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // First Name Label
                const Text(
                  'First Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PlusJakartaSans',
                    color: Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 8),
                // First Name TextField
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: 'Your First Name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PlusJakartaSans',
                      color: Color(0xFF6C7278),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1D61E7)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Last Name Label
                const Text(
                  'Last Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PlusJakartaSans',
                    color: Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 8),
                // Last Name TextField
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Your Last Name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PlusJakartaSans',
                      color: Color(0xFF6C7278),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1D61E7)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Email Label
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PlusJakartaSans',
                    color: Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 8),
                // Email TextField
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'abc@example.com',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PlusJakartaSans',
                      color: Color(0xFF6C7278),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1D61E7)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Password Label
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PlusJakartaSans',
                    color: Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 8),
                // Password TextField
                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: '••••••••••••••••••••',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'PlusJakartaSans',
                      color: Color(0xFF6C7278),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Color(0xFFACB5BB),
                        size: 20,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFEDF1F3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1D61E7)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const Spacer(),
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            } else if (password.length < 12) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password must be at least 12 characters',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                              AuthSignUpWithEmail(
                                email: email,
                                password: password,
                              ),
                            );

                            emailController.clear();
                            passwordController.clear();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D61E7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PlusJakartaSans',
                          color: Color(0xFF6C7278),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          '  Login',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Color(0xFF1D61E7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
