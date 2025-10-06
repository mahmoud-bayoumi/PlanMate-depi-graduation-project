import 'package:flutter/material.dart';

class ManageProfileScreen extends StatelessWidget {
  const ManageProfileScreen({super.key});

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
            fontFamily: 'PlusJakartaSans',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color:  Color(0xFF181D27),
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
              
              const SizedBox(height: 16),
              
              const Text(
                'User Name',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color:  Color(0xFF181D27),
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
                  color: Color(0xFFABABAB)
                ),
              ),
              
              const SizedBox(height: 5),
              
              _buildInputField(
                label: 'First Name',
                placeholder: 'Mahmoud...',
              ),
              
              const SizedBox(height: 15),
              
              _buildInputField(
                label: 'Last Name',
                placeholder: 'Mohamed...',
              ),
              
              const SizedBox(height: 15),
              
              _buildInputField(
                label: 'Birth Date',
                placeholder: '22-02-2000...',
              ),
              
              const SizedBox(height: 140),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D61E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6C7278),
            letterSpacing: 0.02,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE2E2E2),
              width: 1,
            ),
          ),

          child: TextField(
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color:Color(0xFF1A1C1E),
              letterSpacing: 0.01,
            ),

            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Color(0x801A1C1E),
                letterSpacing: 0.01,
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}