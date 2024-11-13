import 'package:flutter/material.dart';
import 'package:cartunn/components/button.dart';
import 'package:cartunn/shared/presentation/widgets/textfield.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: TextEditingController(),
            label: 'First name',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: TextEditingController(),
            label: 'Last name',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: TextEditingController(),
            label: 'Password',
            obscureText: true, // Hide password
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: TextEditingController(),
            label: 'Confirm your password',
            obscureText: true, // Hide password
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'SAVE CHANGES',
            buttonColor: const Color(0xFF5766f5),
            textColor: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
