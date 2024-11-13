import 'package:cartunn/features/settings/domain/entities/profile.dart';
import 'package:cartunn/features/settings/domain/usescases/get_profile_usecase.dart';
import 'package:cartunn/features/settings/domain/usescases/update_profile_usecase.dart';
import 'package:cartunn/shared/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final GetProfileUsecase getProfile;
  final UpdateProfileUsecase updateProfile;
  final int profileId;

  const ProfilePage({
    Key? key,
    required this.getProfile,
    required this.updateProfile,
    required this.profileId,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
  }

  Future<void> _loadProfile() async {
    final profile = await widget.getProfile(widget.profileId);
    setState(() {
      nameController = TextEditingController(text: profile.name);
      lastNameController = TextEditingController(text: profile.lastName);
      emailController = TextEditingController(text: profile.email);
      isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    final updatedProfile = Profile(
      id: widget.profileId,
      name: nameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
    );
    await widget.updateProfile(updatedProfile);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CustomTextField(
            controller: nameController,
            label: 'Name',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: lastNameController,
            label: 'Last Name',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: emailController,
            label: 'Email',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfile,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
