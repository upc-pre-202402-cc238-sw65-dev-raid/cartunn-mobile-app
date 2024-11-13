import 'package:cartunn/features/settings/domain/usescases/get_profile_usecase.dart';
import 'package:cartunn/features/settings/domain/usescases/update_profile_usecase.dart';
import 'package:cartunn/features/settings/presentation/pages/help/help_center_page.dart';
import 'package:cartunn/features/settings/presentation/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final GetProfileUsecase getProfile;
  final UpdateProfileUsecase updateProfile;
  final int profileId;

  const SettingsPage({
    Key? key,
    required this.getProfile,
    required this.updateProfile,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Profile section
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF5766F5)),
                  title: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          getProfile: getProfile,
                          updateProfile: updateProfile,
                          profileId: profileId,
                        ),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Color.fromARGB(255, 158, 158, 158), width: 0.5),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),

          // Help & Center section
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  leading: const Icon(Icons.help, color: Color(0xFF5766F5)),
                  title: const Text(
                    'Help & Center',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpCenterPage()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),

          // Logout section
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xFF5766F5)),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // Basura wiii
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
