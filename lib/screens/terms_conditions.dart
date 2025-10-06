import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          'Terms & Conditions',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF181D27),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              _buildSection(
                title: '1. Acceptance of Terms',
                content: 'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
              ),
              
              const SizedBox(height: 24),
              
              _buildSection(
                title: '2. Use License',
                content: 'Permission is granted to temporarily download one copy of the materials on this application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
              ),
              
              const SizedBox(height: 24),
              
              _buildSection(
                title: '3. User Account',
                content: 'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.',
              ),
              
              const SizedBox(height: 24),
              
              _buildSection(
                title: '4. Privacy Policy',
                content: 'Your use of the application is also governed by our Privacy Policy. Please review our Privacy Policy, which also governs the site and informs users of our data collection practices.',
              ),
              
              const SizedBox(height: 24),
              
              _buildSection(
                title: '5. Modifications',
                content: 'We may revise these terms of service at any time without notice. By using this application you are agreeing to be bound by the then current version of these terms of service.',
              ),
              
              const SizedBox(height: 24),
              
              _buildSection(
                title: '6. Contact Information',
                content: 'If you have any questions about these Terms & Conditions, please contact us through the Support section in the application.',
              ),
              
              const SizedBox(height: 40),
              
              Center(
                child: Text(
                  'Last updated: October 2025',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF181D27),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }
}